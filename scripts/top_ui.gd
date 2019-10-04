extends TextureRect

onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel
onready var counter_label = $MarginContainer/HBoxContainer/CounterLabel
onready var score_bar = $MarginContainer/HBoxContainer/VBoxContainer/TextureProgress
#onready var goal_container = $MarginContainer/HBoxContainer/HBoxContainer 
onready var goal_container = $"EscañosMarginContainer/EscañosBoxContainer"
export (PackedScene) var goal_prefab
var current_score = 0
var current_counter = 0

func _ready():
	_on_grid_update_score(0)

func _on_grid_update_score(new_value):
	current_score = get_pertentage_seats(get_total_seats())
	#score_label.text = String(current_score)
	score_label.text = String("%.2f" % current_score) + '%'
	update_score_bar()

func _on_grid_update_counter(new_value = -1):	
	current_counter += new_value	
	counter_label.text = String(current_counter)
	
func setup_score_bar(max_score):
	# We don't need this because we make the score bar by %
	#score_bar.max_value = max_score
	pass

func update_score_bar():
	#score_bar.value = current_score
	get_pertentage_seats(get_total_seats())
	score_bar.value = current_score

func get_pertentage_seats(seats):
	return (seats / Utils.MAX_NUMBER_SEATS) * 100

func get_total_seats():
	var current_sum = 0.0
	for i in goal_container.get_child_count():
		current_sum += goal_container.get_child(i).current_number
	# If the last combo adds more value to the sum than the MAX_NUMBER_SEATS the score bar goes beyond 100%
	if current_sum > Utils.MAX_NUMBER_SEATS:
		current_sum = Utils.MAX_NUMBER_SEATS
	return current_sum

func make_goal(goal):
	var current = goal_prefab.instance()
	goal_container.add_child(current)
	current.set_goal_values(goal)

func _on_grid_setup_max_score(max_score):
	setup_score_bar(max_score)

func _on_GoalHolder_create_goal(goal):
	make_goal(goal)

func _on_grid_check_goal(goal_type):
	if !Utils.GAME_ALREADY_END:
		for i in goal_container.get_child_count():
			goal_container.get_child(i).update_goal_values(goal_type)
			print("The: ", goal_type, goal_container.get_child(i).current_number)
		
	reorganize_seats()

func reorganize_seats():
	# Bubble sort
	for i in goal_container.get_child_count(): 
		for inner_i in range(goal_container.get_child_count() - i):
			if (inner_i + 1) < goal_container.get_child_count():
				var current_goal : Node = goal_container.get_child(inner_i)
				var next_goal : Node = goal_container.get_child(inner_i + 1)
				if current_goal.current_number < next_goal.current_number:
					goal_container.remove_child(current_goal)
					goal_container.add_child_below_node(next_goal, current_goal)
	Utils.win_color = get_winner_color()

#Return winner color
func get_winner_color():
	if is_draw(): return "draw"
	else: return goal_container.get_child(0).goal_target

func is_draw():
	return goal_container.get_child(0).current_number == goal_container.get_child(1).current_number
	
func _on_ice_holder_break_ice(goal_type):
	_on_grid_check_goal(goal_type)