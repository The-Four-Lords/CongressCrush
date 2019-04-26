extends Node2D

signal remove_lock

var lock_pieces = []
var width = 8
var height = 10
var licorice = preload("res://scenes/licorice.tscn")

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

func _on_grid_make_lock(board_position):
	if lock_pieces.size() == 0:
		lock_pieces = make_2d_array()
	var current = licorice.instance()
	add_child(current)
	current.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 800)
	lock_pieces[board_position.x][board_position.y] = current


func _on_grid_damage_lock(board_position):
	if lock_pieces.size() > 0:
		var lock_piece = lock_pieces[board_position.x][board_position.y]
		if lock_piece != null:
			lock_piece.take_damage(1)
			if lock_piece.health <= 0:
				lock_piece.queue_free()
				lock_pieces[board_position.x][board_position.y] = null
				emit_signal("remove_lock", board_position)
