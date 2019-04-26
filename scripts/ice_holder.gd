extends Node2D

signal remove_ice

var ice_pieces = []
var width = 8
var height = 10
var ice = preload("res://scenes/ice.tscn")

# Goal Signal Stuff
signal break_ice
export (String) var value

func _ready():
	pass

func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func _on_grid_make_ice(board_position):
	if ice_pieces.size() == 0:
		ice_pieces = make_2d_array()
	var current = ice.instance()
	add_child(current)
	current.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 800)
	ice_pieces[board_position.x][board_position.y] = current


func _on_grid_damage_ice(board_position):
	if ice_pieces.size() > 0:
		var ice_piece = ice_pieces[board_position.x][board_position.y]
		if ice_piece != null:
			ice_piece.take_damage(1)
			if ice_piece.health <= 0:
				ice_piece.queue_free()
				ice_pieces[board_position.x][board_position.y] = null
				emit_signal("remove_ice", board_position)
				emit_signal("break_ice", value)
