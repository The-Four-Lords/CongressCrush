extends Node

# Max numbers of seats in the Congress
const MAX_NUMBER_SEATS = 350
# Difficulty level: easy, medium, hard
const GLOBAL_PIECE_VALUES_ACCORDING_LEVEL = {
"easy" :6, 
"medium" : 4,
"hard" : 2
}
var global_piece_value = GLOBAL_PIECE_VALUES_ACCORDING_LEVEL["hard"] # Hard by default

var GAME_ALREADY_END = false;

var CURRENT_SEAT_COUNT = 0;

var win_color

var counter_label_node

var empty_spaces_dictionary = [
	{
		key = '0',
		value = PoolVector2Array([
			Vector2(0,3),
			Vector2(1,3),
			Vector2(0,4),
			Vector2(1,4),
			Vector2(0,5),
			Vector2(1,5),
			Vector2(0,6),
			Vector2(1,6),
			Vector2(6,3),
			Vector2(7,3),
			Vector2(6,4),
			Vector2(7,4),
			Vector2(6,5),
			Vector2(7,5),
			Vector2(6,6),
			Vector2(7,6)
			])
	},
	{
		key = '1',
		value = PoolVector2Array([
			Vector2(0,0),
			Vector2(7,0),
			Vector2(0,9),
			Vector2(7,9),
			Vector2(3,4),
			Vector2(4,4),
			Vector2(3,5),
			Vector2(4,5)
			])
	},
	{
		key = '2',
		value = PoolVector2Array([
			Vector2(0,9),
			Vector2(1,9),
			Vector2(0,8),
			Vector2(1,8),
			Vector2(6,9),
			Vector2(7,9),
			Vector2(6,8),
			Vector2(7,8),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(3,0),
			Vector2(4,0),
			Vector2(5,0),
			Vector2(6,0),
			Vector2(3,1),
			Vector2(4,1)
			])
	},
	{
		key = '3',
		value = PoolVector2Array([])
	},
	{
		key = '4',
		value = PoolVector2Array([
		Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(3,0), Vector2(4,0), Vector2(5,0), Vector2(6,0), Vector2(7,0),
		Vector2(0,1), Vector2(1,1), Vector2(2,1), Vector2(4,1), Vector2(5,1), Vector2(6,1), Vector2(7,1),
		Vector2(0,2), Vector2(1,2), Vector2(6,2), Vector2(7,2),
		Vector2(0,3), Vector2(1,3), Vector2(6,3), Vector2(7,3),
		Vector2(0,4), Vector2(1,4), Vector2(7,4),
		Vector2(0,5), Vector2(1,5), Vector2(7,5),
		Vector2(0,6), Vector2(1,6), Vector2(7,6),
		Vector2(0,9), Vector2(1,9), Vector2(2,9), Vector2(3,9), Vector2(4,9), Vector2(5,9), Vector2(6,9), Vector2(7,9)
		])
	},
	{
		key = '5',
		value = PoolVector2Array([
		Vector2(2,0), Vector2(3,0), Vector2(4,0), Vector2(5,0),
		Vector2(2,1), Vector2(3,1), Vector2(4,1), Vector2(5,1),
		Vector2(1,4), Vector2(2,4), Vector2(5,4), Vector2(6,4),
		Vector2(1,6), Vector2(3,6), Vector2(4,6), Vector2(6,6),
		Vector2(1,8), Vector2(2,8), Vector2(5,8), Vector2(6,8),
		Vector2(1,9), Vector2(2,9), Vector2(5,9), Vector2(6,9)
		])
	}
	
]

func get_random_empty_spaces(rand):
	return empty_spaces_dictionary[rand].value

func get_empty_spaces_dictionary_size():
	return empty_spaces_dictionary.size()

func initialize_preset_spaces():
	return PoolVector3Array([
			Vector3(0, 0, 0),
			Vector3(1, 0, 0),
			Vector3(2, 0, 1),
			Vector3(3, 0, 0),
			Vector3(4, 0, 0),
			Vector3(0, 1, 1),
			Vector3(1, 1, 1),
			Vector3(2, 1, 0),
			Vector3(3, 1, 1),
			Vector3(4, 1, 1),
			])

func initialize_empty_spaces():
	return PoolVector2Array([
			Vector2(0,9),
			Vector2(1,9),
			Vector2(0,8),
			Vector2(1,8),
			Vector2(6,9),
			Vector2(7,9),
			Vector2(6,8),
			Vector2(7,8),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(3,0),
			Vector2(4,0),
			Vector2(5,0),
			Vector2(6,0),
			Vector2(3,1),
			Vector2(4,1)
			])

func initialize_special(empty_spaces, ice_spaces, lock_spaces, concrete_spaces, slime_spaces):
	if (empty_spaces.size() == 0):
		empty_spaces = PoolVector2Array([
			Vector2(0, 0),
			Vector2(7, 0),
			Vector2(0, 9),
			Vector2(7, 9),
			Vector2(3, 4),
			Vector2(4, 4),
			Vector2(3, 5),
			Vector2(4, 5)
		])
	if (ice_spaces.size() == 0):
		ice_spaces = PoolVector2Array([
			Vector2(3, 0),
			Vector2(4, 0),
			Vector2(3, 9),
			Vector2(4, 9)
		])
	if (lock_spaces.size() == 0):
		lock_spaces = PoolVector2Array([
			Vector2(3, 2),
			Vector2(4, 2),
			Vector2(3, 7),
			Vector2(4, 7)
		])
	if (concrete_spaces.size() == 0):
		concrete_spaces = PoolVector2Array([
			Vector2(3, 1),
			Vector2(4, 1),
			Vector2(3, 8),
			Vector2(4, 8)
		])
	if (slime_spaces.size() == 0):
		slime_spaces = PoolVector2Array([
			Vector2(0, 4),
			Vector2(0, 5),
			Vector2(7, 4),
			Vector2(7, 5)
		])