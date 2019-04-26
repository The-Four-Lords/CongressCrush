extends Node2D

signal remove_slime

var slime_pieces = []
var width = 8
var height = 10
var slime = preload("res://scenes/slime.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func _on_grid_make_slime(board_position):
	if slime_pieces.size() == 0:
		slime_pieces = make_2d_array()
	var current = slime.instance()
	add_child(current)
	current.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 800)
	slime_pieces[board_position.x][board_position.y] = current


func _on_grid_damage_slime(board_position):
	if slime_pieces.size() > 0:
		var slime_piece = slime_pieces[board_position.x][board_position.y]
		if slime_piece != null:
			slime_piece.take_damage(1)
			if slime_piece.health <= 0:
				slime_piece.queue_free()
				slime_pieces[board_position.x][board_position.y] = null
				emit_signal("remove_slime", board_position)
