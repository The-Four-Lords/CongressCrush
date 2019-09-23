extends Node2D

var random_panel = 0

# State Machine - Added states: swapBack, destroy, collapse and refill in order to do this actions only if is needed
enum {wait, move, swapBack, destroy, collapse, refill, win}
var state = wait

# Constants for bomb combinations
const COLUMN_COLOR_BOMB = 5
const ROW_COLOR_BOMB = 5
const COLUMN_ADJACENT_BOMB = 3
const ROW_ADJACENT_BOMB = 3
const COLUMN_BOMB = 4
const ROW_BOMB = 4

# Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
export (int) var y_offset

# Obstacle Stuff
export (PoolVector2Array) var empty_spaces
export (PoolVector2Array) var ice_spaces
export (PoolVector2Array) var lock_spaces
export (PoolVector2Array) var concrete_spaces
export (PoolVector2Array) var slime_spaces
var damaged_slime = false

# Obstacle Signals
signal make_ice
signal damage_ice
signal make_lock
signal damage_lock
signal make_concrete
signal damage_concrete
signal make_slime
signal damage_slime

# Preset Board
export (bool) var isDemo
export (PoolVector3Array) var preset_spaces

# First Turn
var firstTurn

# The piece array
var possible_pieces = [
preload("res://scenes/Piece/cs_piece.tscn"),
preload("res://scenes/Piece/erc_piece.tscn"),
preload("res://scenes/Piece/podemos_piece.tscn"),
preload("res://scenes/Piece/pp_piece.tscn"),
preload("res://scenes/Piece/psoe_piece.tscn"),
preload("res://scenes/Piece/vox_piece.tscn")
]

# Hint Stuff
export (PackedScene) var hint_effect
var hint = null
var hint_color = "";

# The current pieces in the scene
var all_pieces = []
var clone_array = []
var current_matches = []

# Swap Back Variables
var tempSwapBack = {
	'column': '',
	'row': '',
	'direction': ''
}

# Touch Variables
var first_touch = Vector2(0, 0)
var final_touch = Vector2(0, 0)
var controlling = false

# Scoring Variables
signal update_score
export (int) var piece_value
var streak = 1
export (int) var max_score
signal setup_max_score

# Counter Variables
signal update_counter
signal game_over
export (int) var current_counter_value
export (bool) var is_counter_in_moves

# Goal Check Stuff
signal check_goal

#was color bomb used?
var color_bomb_used = false

# Collectible/Sinker Stuff
export (PackedScene) var sinker_piece
export (bool) var sinkers_in_scene
export (int) var max_sinkers
var current_sinkers = 0

# Effects
var particle_effect = preload("res://scenes/ParticleEffect.tscn")
var animated_explosion_effect = preload("res://scenes/AnimatedExplosion.tscn")

# Sounds
signal play_sound

# Camera Stuff
signal place_camera
signal camera_effect

func _ready():
	init_game()

func move_camera():
	var new_pos = grid_to_pixel(width / 2 - 0.5, height / 2 - 0.5)
	emit_signal("place_camera", new_pos)

func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func spawn_pieces():
	sinkers_logic()
	var found = false
	randomize()
	for i in width:
		for j in height:
			if is_piece_null(all_pieces[i][j]):
				# Check non spawneable spots
				if !restricted_fill(Vector2(i, j)):
					setState(wait)
					# Choose a random number and store it
					var rand = floor(rand_range(0, possible_pieces.size()))
					# Instance that piece from the array
					var piece = possible_pieces[rand].instance()
					var loops = 0
					while (match_at(i, j, piece.color) && loops < 100):
						rand = floor(rand_range(0, possible_pieces.size()))
						loops += 1
						piece = possible_pieces[rand].instance()
					add_child(piece)
					piece.position = grid_to_pixel(i, j + y_offset)
					piece.move(grid_to_pixel(i, j))
					all_pieces[i][j] = piece
					found = find_matches()
	if !found:
		# At the end of the combo check if slimes has been damaged, if not, create a new one
		if !damaged_slime and !firstTurn:
			generate_slime()
		damaged_slime = false
		if is_counter_in_moves and !firstTurn:
			current_counter_value -= 1 
			emit_signal("update_counter")
		if current_counter_value == 0:
			declare_game_over()
		elif is_deadlocked():
			$regenerate_board.start()
		else: setState(move)
	else:
		streak += 1

func is_piece_sinker(piece):
	return !is_piece_null(piece) and piece.color == "None"

func spawn_ice():
	for i in ice_spaces.size():
		emit_signal("make_ice", ice_spaces[i])

func spawn_lock():
	for i in lock_spaces.size():
		emit_signal("make_lock", lock_spaces[i])

func spawn_concrete():
	for i in concrete_spaces.size():
		emit_signal("make_concrete", concrete_spaces[i])

func spawn_slime():
	for i in slime_spaces.size():
		emit_signal("make_slime", slime_spaces[i])

func spawn_sinker(number_to_spawn):
	for i in number_to_spawn:
		randomize()
		var column = floor(rand_range(0, width))
		var row = height - 1
		while is_piece_sinker(all_pieces[column][row]) or restricted_fill(Vector2(column, row)):
			randomize()
			column = floor(rand_range(0, width))
		var current = sinker_piece.instance()
		add_child(current)
		if !is_piece_null(all_pieces[column][row]): all_pieces[column][row].queue_free()
		current.position = grid_to_pixel(column, row)
		all_pieces[column][row] = current
		current_sinkers += 1

func spawn_preset_pieces():
	if preset_spaces != null:
		if preset_spaces.size() > 0:
			for i in preset_spaces.size():
				var piece = possible_pieces[preset_spaces[i].z].instance()
				var current_column = preset_spaces[i].x
				var current_row = preset_spaces[i].y
				add_child(piece)
				piece.position = grid_to_pixel(current_column, current_row)
				all_pieces[current_column][current_row ] = piece
			

func match_at(i, j, color):
	if i > 1:
		if !is_piece_null(all_pieces[i - 1][j]) && !is_piece_null(all_pieces[i - 2][j]):
			if all_pieces[i - 1][j].color == color && all_pieces[i - 2][j].color == color:
				#print('Found match for: ', i, '-', j)
				return true
	if j > 1:
		if !is_piece_null(all_pieces[i][j - 1]) && !is_piece_null(all_pieces[i][j - 2]):
			if all_pieces[i][j - 1].color == color && all_pieces[i][j - 2].color == color:
				#print('Found match for: ', i, '-', j)
				return true
	return false

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	#print('x: ', new_x, ' - y: ', new_y)
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)

func is_in_grid(grid_position):
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true
		return false

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)):
			first_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)
			controlling = true
	if Input.is_action_just_released("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)) && controlling:
			controlling = false;
			final_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)
			touch_difference(first_touch, final_touch)

func swap_pieces(column, row, direction):
	var first_piece = all_pieces[column][row]
	var other_piece = all_pieces[column + direction.x][row + direction.y]
	if !is_piece_null(first_piece) and !is_piece_null(other_piece):
		if !poolvector2Array_has(lock_spaces, Vector2(column, row)) and !poolvector2Array_has(lock_spaces, Vector2(column, row) + direction):
			all_pieces[column][row] = other_piece
			all_pieces[column + direction.x][row + direction.y] = first_piece
			first_piece.move(grid_to_pixel(column + direction.x, row + direction.y))
			other_piece.move(grid_to_pixel(column, row))
			setTempSwapBack(column, row, direction)
			if first_piece.is_color_bomb or other_piece.is_color_bomb:
				color_bomb_checks(first_piece, other_piece, column, row)
			if state != swapBack:
				var found = find_matches()
				if !found:
					setState(swapBack)
					get_parent().get_node("swap_back_timer").start()
			else:
				color_bomb_used = false
				setState(move)

func color_bomb_checks(piece_one, piece_two, column, row):
	if piece_one.is_color_bomb and piece_two.is_color_bomb:
		clear_board()
	else:
		# When combine a color bomb, the status must change to destroy in order to delete the color pieces
		if !is_piece_sinker(piece_one) and !is_piece_sinker(piece_two):
			color_bomb_used = true
			setState(destroy)
			if piece_one.is_color_bomb:
				match_color(piece_two.color)
				turn_matched(piece_one)
				add_to_array(Vector2(column, row))
			if piece_two.is_color_bomb:
				match_color(piece_one.color)
				turn_matched(piece_two)
				add_to_array(Vector2(column, row))

func touch_difference(grid_1, grid_2):
	var difference = grid_2 - grid_1
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(1, 0))
		elif difference.x < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(-1, 0))
	elif abs(difference.y) > abs(difference.x):
		if difference.y > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, 1))
		elif difference.y < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, -1))

#warning-ignore:unused_argument
func _process(delta):
	if state == move:
		touch_input()

func find_matches(query = false, pieces_array = all_pieces):
	for i in width:
		for j in height:
			if !is_piece_null(pieces_array[i][j]) and !is_piece_sinker(pieces_array[i][j]):
				var current_color = pieces_array[i][j].color
				if i > 0 and i < width - 1:
					if !is_piece_null(pieces_array[i - 1][j]) and !is_piece_null(pieces_array[i + 1][j]):
						if pieces_array[i - 1][j].color == current_color && pieces_array[i + 1][j].color == current_color:
							if query:
								hint_color = current_color 
								return true
							setState(destroy)
							turn_matched(pieces_array[i - 1][j])
							turn_matched(pieces_array[i][j])
							turn_matched(pieces_array[i + 1][j])
							add_to_array(Vector2(i - 1, j))
							add_to_array(Vector2(i, j))
							add_to_array(Vector2(i + 1, j))
				if j > 0 and j < height - 1:
					if !is_piece_null(pieces_array[i][j - 1]) and !is_piece_null(pieces_array[i][j + 1]):
						if pieces_array[i][j - 1].color == current_color && pieces_array[i][j + 1].color == current_color:
							if query:
								hint_color = current_color
								return true
							setState(destroy)
							turn_matched(pieces_array[i][j - 1])
							turn_matched(pieces_array[i][j])
							turn_matched(pieces_array[i ][j + 1])
							add_to_array(Vector2(i, j - 1))
							add_to_array(Vector2(i, j))
							add_to_array(Vector2(i, j + 1))
			elif is_piece_sinker(pieces_array[i][j]) and j == 0:
				setState(destroy)
				if !pieces_array[i][j].matched: 
					current_sinkers -= 1
					turn_matched(pieces_array[i][j])
					add_to_array(Vector2(i, j))
	if state == destroy:
		get_bombed_pieces()
		get_parent().get_node("destroy_timer").start()
		return true
	return false

func get_bombed_pieces():
	for i in width:
		for j in height:
			var current_piece = all_pieces[i][j]
			if !is_piece_null(current_piece) and current_piece.matched:
				if all_pieces[i][j].is_column_bomb:
					match_all_in_column(i)
				elif all_pieces[i][j].is_row_bomb:
					match_all_in_row(j)
				elif all_pieces[i][j].is_adjacent_bomb:
					find_adjacent_pieces(i, j)

func add_to_array(value, array_to_add = current_matches):
	if !array_to_add.has(value):
		array_to_add.append(value)

func is_piece_null(piece):
	return piece == null

func turn_matched(piece):
	piece.matched = true
	piece.dim()

func find_bombs():
	if !color_bomb_used:
		# Iterate over the current matches array
		for i in current_matches.size():
			var current_column = current_matches[i].x
			var current_row = current_matches[i].y
			var current_color = all_pieces[current_column][current_row].color
			var column_matched = 0
			var row_matched = 0
			for j in current_matches.size():
				var this_column = current_matches[j].x
				var this_row = current_matches[j].y
				var this_color = all_pieces[this_column][this_row].color
				if this_column == current_column and this_color == current_color:
					column_matched += 1
				if this_row == current_row and this_color == current_color:
					row_matched += 1
			if column_matched == COLUMN_COLOR_BOMB or row_matched == ROW_COLOR_BOMB:
				#print("DEBUG - color bomb | column_matched: ", column_matched, " row_matched: " , row_matched)
				make_bomb(3, current_color)
				continue
			elif column_matched >= COLUMN_ADJACENT_BOMB and row_matched >= ROW_ADJACENT_BOMB:
				#print("DEBUG - adjacent bomb | column_matched: ", column_matched, " row_matched: " , row_matched)
				make_bomb(0, current_color)
				continue
			# In row matched make column bomb
			elif row_matched == ROW_BOMB:
				#print("DEBUG - column bomb | column_matched: ", column_matched, " row_matched: " , row_matched)
				make_bomb(1, current_color)
				continue
			# In column matched make row bombs
			elif column_matched == COLUMN_BOMB:
				#print("DEBUG - row bomb | column_matched: ", column_matched, " row_matched: " , row_matched)
				make_bomb(2, current_color)
				continue
			elif column_matched == 4 or row_matched == 4:
				SoundManager.play_random_combo_sound()
				continue

# bomb_type: 0 is adjacent, 1 is column bomb. 2 is row bomb and 3 is color bomb
func make_bomb(bomb_type, color):
	var piece_one = all_pieces[tempSwapBack.column][tempSwapBack.row]
	var piece_two = all_pieces[tempSwapBack.column + tempSwapBack.direction.x][tempSwapBack.row + tempSwapBack.direction.y]
	for i in current_matches.size():
		var current_column = current_matches[i].x
		var current_row = current_matches[i].y
		if all_pieces[current_column][current_row] == piece_one and piece_one.color == color:
			damage_special(current_column, current_row)
			emit_signal("check_goal", piece_one.color)
			piece_one.matched = false
			change_bomb(bomb_type, piece_one)
		if all_pieces[current_column][current_row] == piece_two and piece_two.color == color:
			damage_special(current_column, current_row)
			emit_signal("check_goal", piece_two.color)
			piece_two.matched = false
			change_bomb(bomb_type, piece_two)

func change_bomb(bomb_type, piece):
	SoundManager.play_random_combo_sound()
	if bomb_type == 0:
		piece.make_adjacent_bomb()
	elif bomb_type == 1:
		piece.make_column_bomb()
	elif bomb_type == 2:
		piece.make_row_bomb()
	elif bomb_type == 3:
		piece.make_color_bomb()

func destroy_matched():
	find_bombs()
	for i in width:
		for j in height:
			if !is_piece_null(all_pieces[i][j]):
				if all_pieces[i][j].matched:
					setState(collapse)
					emit_signal("check_goal", all_pieces[i][j].color)
					damage_special(i, j);
					all_pieces[i][j].queue_free()
					all_pieces[i][j] = null
					make_effect(animated_explosion_effect, i, j)
					make_effect(particle_effect, i, j)
					emit_signal("play_sound")
					cam_effect()
					#print("DEBUG - Update Score | ", piece_value, " streak: ", streak)
					emit_signal("update_score", piece_value * streak)
	if state == collapse:
		get_parent().get_node("collapse_timer").start()
	current_matches.clear()

func make_effect(effect, column, row):
	var current = effect.instance()
	current.position = grid_to_pixel(column, row)
	add_child(current)

func damage_special(column, row):
	if ice_spaces.size() > 0:
		emit_signal("damage_ice", Vector2(column, row))
	if lock_spaces.size() > 0:
		emit_signal("damage_lock", Vector2(column, row))
	if concrete_spaces.size() > 0:
		check_concrete(column, row)
	if slime_spaces.size() > 0:
		check_slime(column, row)

func match_color(color):
	for i in width:
		for j in height:
			var current_piece = all_pieces[i][j]
			if !is_piece_null(current_piece) and !restricted_fill(Vector2(i, j)) and !is_piece_sinker(current_piece) and current_piece.color == color:
				if current_piece.is_column_bomb:
					match_all_in_column(i)
				elif current_piece.is_row_bomb:
					match_all_in_row(j)
				elif current_piece.is_adjacent_bomb:
					find_adjacent_pieces(i, j)
				turn_matched(current_piece)
				add_to_array(Vector2(i, j))

func clear_board():
	for i in width:
		for j in height:
			var current_piece = all_pieces[i][j]
			if !is_piece_null(current_piece) and !restricted_fill(Vector2(i, j)) and !is_piece_sinker(current_piece):
				setState(destroy)
				turn_matched(current_piece)
				add_to_array(Vector2(i, j))

func destroy_board():
	for i in width:
		for j in height:
			if !is_piece_null(all_pieces[i][j]) and !restricted_fill(Vector2(i, j)) and !is_piece_sinker(all_pieces[i][j]) and !poolvector2Array_has(lock_spaces, Vector2(i, j)):
				all_pieces[i][j].queue_free()
				all_pieces[i][j] = null

func collapse_columns():
	for i in width:
		for j in height:
			if is_piece_null(all_pieces[i][j]) && !restricted_fill(Vector2(i, j)):
				setState(refill)
				for k in range(j + 1, height):
					if !is_piece_null(all_pieces[i][k]):
						all_pieces[i][k].move(grid_to_pixel(i, j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	if state == refill:
		get_parent().get_node("refill_timer").start()

func setState(newState):
	if state != newState:
		#print('DEBUG - state goes from: ', state, ' to: ', newState)
		state = newState
		if state == move:
			streak = 1
			$hint_timer.start()
		else :
			liberate_hint()

func setTempSwapBack(column, row, direction):
	tempSwapBack.column = column;
	tempSwapBack.row = row;
	tempSwapBack.direction = direction;

func check_concrete(column, row):
	# Check right
	if column < width - 1:
		emit_signal("damage_concrete", Vector2(column + 1, row))
	# Check left
	if column > 0:
		emit_signal("damage_concrete", Vector2(column - 1, row))
	if row < height - 1:
		emit_signal("damage_concrete", Vector2(column, row + 1))
	if row > 0:
		emit_signal("damage_concrete", Vector2(column, row - 1))

func check_slime(column, row):
	# Check right
	if column < width - 1:
		emit_signal("damage_slime", Vector2(column + 1, row))
	# Check left
	if column > 0:
		emit_signal("damage_slime", Vector2(column - 1, row))
	if row < height - 1:
		emit_signal("damage_slime", Vector2(column, row + 1))
	if row > 0:
		emit_signal("damage_slime", Vector2(column, row - 1))

func generate_slime():
	# Make sure there are  slime pieces on the board
	if slime_spaces.size() > 0:
		var slime_made = false
		var tracker = 0
		while !slime_made and tracker < 100:
			# Check random slime
			randomize()
			var random_num = floor(rand_range(0, slime_spaces.size()))
			var neighbor = find_normal_neighbord(slime_spaces[random_num].x, slime_spaces[random_num].y)
			if neighbor != null:
				# Turn the neighbor piece into a slime
				all_pieces[neighbor.x][neighbor.y].queue_free()
				all_pieces[neighbor.x][neighbor.y] = null
				var new_slime = Vector2(neighbor.x, neighbor.y)
				slime_spaces.append(new_slime)
				emit_signal("make_slime", new_slime)
				slime_made = true
			tracker += 1

func find_normal_neighbord(column, row):
	# Check right
	var column_right = column + 1
	if is_in_grid(Vector2(column_right, row)) and !is_piece_null(all_pieces[column_right][row]) and !is_piece_sinker(all_pieces[column_right][row]):
		return Vector2(column_right, row)
	# Check left
	var column_left = column - 1
	if is_in_grid(Vector2(column_left, row)) and !is_piece_null(all_pieces[column_left][row]) and !is_piece_sinker(all_pieces[column_left][row]):
		return Vector2(column_left, row)
	# Check up
	var row_up = row + 1
	if is_in_grid(Vector2(column, row_up)) and !is_piece_null(all_pieces[column][row_up]) and !is_piece_sinker(all_pieces[column][row_up]):
		return Vector2(column, row_up)
	# Check down
	var row_down = row + 1
	if is_in_grid(Vector2(column, row_down)) and !is_piece_null(all_pieces[column][row_down]) and !is_piece_sinker(all_pieces[column][row_down]):
		return Vector2(column, row_down)
	return null

func restricted_fill(place):
	if poolvector2Array_has(empty_spaces, place) or poolvector2Array_has(concrete_spaces, place) or poolvector2Array_has(slime_spaces, place):
		return true
	return false

func poolvector2Array_has(pool_vector_array, prop):
	for i in pool_vector_array.size():
		if pool_vector_array[i] == prop:
			return true
	return false

func poolvector2Array_getIndex(pool_vector_array, prop):
	for i in pool_vector_array.size():
		if pool_vector_array[i] == prop:
			return i
	return -1

func match_all_in_column(column):
	for i in height:
		var current_piece = all_pieces[column][i]
		if !is_piece_null(current_piece) and !is_piece_sinker(current_piece):
			if current_piece.is_row_bomb:
				match_all_in_row(i)
			if current_piece.is_adjacent_bomb:
				find_adjacent_pieces(column, i)
			if current_piece.is_color_bomb:
				match_color(current_piece.color)
			current_piece.matched = true

func match_all_in_row(row):
	for i in width:
		var current_piece = all_pieces[i][row]
		if !is_piece_null(current_piece) and !is_piece_sinker(current_piece):
			if current_piece.is_column_bomb:
				match_all_in_column(i)
			if current_piece.is_adjacent_bomb:
				find_adjacent_pieces(i, row)
			if current_piece.is_color_bomb:
				match_color(current_piece.color)
			current_piece.matched = true

func find_adjacent_pieces(column, row):
	for i in range(-1, 2):
		for j in range(-1, 2):
			var current_column = column + i
			var current_row = row + j
			var current_piece = all_pieces[current_column][current_row]
			if is_in_grid(Vector2(column + i, row + j)):
				if !is_piece_null(current_piece) and !is_piece_sinker(current_piece):
					if current_piece.is_row_bomb:
						match_all_in_row(j)
					if current_piece.is_column_bomb:
						match_all_in_column(i)
					if current_piece.is_color_bomb:
						match_color(current_piece.color)
					current_piece.matched = true

func sinkers_logic():
	if sinkers_in_scene and current_sinkers < max_sinkers: 
		spawn_sinker(max_sinkers - current_sinkers)

func declare_game_over():
	emit_signal("game_over")
	setState(wait)

func switch_pieces(place, direction, array):
	if is_in_grid(Vector2(place.x, place.y)) and !restricted_fill(place) and is_in_grid(Vector2(place.x + direction.x, place.y + direction.y)) and !restricted_fill(place + direction):
		var holder = array[place.x + direction.x][place.y + direction.y]
		array[place.x + direction.x][place.y + direction.y] = array[place.x][place.y]
		array[place.x][place.y] = holder

func is_deadlocked():
	# Create a copy of the all_pieces array
	clone_array = copy_array(all_pieces)
	for i in width:
		for j in height:
			# Switch and check right position
			if switch_and_check(Vector2(i, j), Vector2(1, 0), clone_array): return false
			# Switch and check up position
			if switch_and_check(Vector2(i, j), Vector2(0, 1), clone_array): return false
	return true

func switch_and_check(place, direction, array):
	switch_pieces(place, direction, array)
	if find_matches(true, array):
		switch_pieces(place, direction, array)
		return true
	switch_pieces(place, direction, array)
	return false

func copy_array(array_to_copy):
	var new_array = make_2d_array()
	for i in width:
		for j in height:
			new_array[i][j] = array_to_copy[i][j]
	return new_array
	
func regenerate_board():
	destroy_board()
	init_game(true)
	start_spawn()
	
func init_game(regeneration = false):
	SoundManager.disable_sounds(false)
	SoundManager.disable_sounds(true)
	move_camera()
	firstTurn = true
	all_pieces = make_2d_array()
	clone_array = make_2d_array()
	if !regeneration:
		emit_signal("update_counter", current_counter_value)
		emit_signal("setup_max_score", max_score)
		if !is_counter_in_moves:
			$game_time.start()
	color_bomb_used = false
	streak = 1
	#Utils.initialize_special(empty_spaces, ice_spaces, lock_spaces, concrete_spaces, slime_spaces)
	#empty_spaces = Utils.initialize_empty_spaces() # constant panel
	randomize()
	random_panel = randi() % Utils.get_empty_spaces_dictionary_size()
	empty_spaces = Utils.get_random_empty_spaces(random_panel)

func start_spawn():
	if isDemo:
		#preset_spaces = Utils.initialize_preset_spaces() # constant panel
		preset_spaces = Utils.get_random_empty_spaces(random_panel)
		spawn_preset_pieces()
	else:
		spawn_ice()
		spawn_lock()
		spawn_concrete()
		spawn_slime()
	spawn_pieces()
	firstTurn = false

func find_all_matches():
	var hint_holder = []
	clone_array = copy_array(all_pieces)
	
	for i in width:
		for j in height:
			# Switch and check right position
			if switch_and_check(Vector2(i, j), Vector2(1, 0), clone_array):
				if hint_color != "":
					if hint_color == clone_array[i][j].color: hint_holder.append(clone_array[i][j])
					else: hint_holder.append(clone_array[i + 1][j])
			# Switch and check up position
			elif switch_and_check(Vector2(i, j), Vector2(0, 1), clone_array): 
				if hint_color != "":
					if hint_color == clone_array[i][j].color: hint_holder.append(clone_array[i][j])
					else: hint_holder.append(clone_array[i][j + 1])
	return hint_holder

func generate_hint():
	var hints = find_all_matches()
	
	if hints != null:
		randomize()
		var rand = floor(rand_range(0, hints.size()))
		if hint_effect != null:
			hint = hint_effect.instance()
			add_child(hint)
			hint.position = hints[rand].position
			hint.Setup(hints[rand].get_node("Sprite").texture)

func liberate_hint():
	$hint_timer.stop()
	if hint != null:
		hint.queue_free()
		hint = null

func cam_effect():
	emit_signal("camera_effect")

func _on_destroy_timer_timeout():
	#print('DEBUG - Destroy')
	destroy_matched()

func _on_collapse_timer_timeout():
	#print('DEBUG - Collapse')
	collapse_columns()

func _on_refill_timer_timeout():
	#print('DEBUG - Refill\n')
	spawn_pieces()

func _on_create_pieces_timer_timeout():
	#print('DEBUG - Create Pieces')
	start_spawn()

func _on_swap_back_timer_timeout():
	#print('DEBUG - Swap Back')
	swap_pieces(tempSwapBack.column, tempSwapBack.row, tempSwapBack.direction)

func _on_ice_holder_remove_ice(place):
	if poolvector2Array_has(ice_spaces, place):
		ice_spaces.remove(poolvector2Array_getIndex(ice_spaces, place))

func _on_lock_holder_remove_lock(place):
	if poolvector2Array_has(lock_spaces, place):
		lock_spaces.remove(poolvector2Array_getIndex(lock_spaces, place))

func _on_concrete_holder_remove_concrete(place):
	if poolvector2Array_has(concrete_spaces, place):
		concrete_spaces.remove(poolvector2Array_getIndex(concrete_spaces, place))

func _on_slime_holder_remove_slime(place):
	damaged_slime = true
	if poolvector2Array_has(slime_spaces, place):
		slime_spaces.remove(poolvector2Array_getIndex(slime_spaces, place))

func _on_Timer_timeout():
	if !is_counter_in_moves and current_counter_value > 0 and state != win:
		current_counter_value -= 1
		emit_signal("update_counter")
		if current_counter_value <= 0:
			declare_game_over()
			$game_time.stop()

func _on_GoalHolder_game_won():
	setState(win)
	$game_time.stop()

func _on_regenerate_board_timeout():
	regenerate_board()

func _on_hint_timer_timeout():
	generate_hint()