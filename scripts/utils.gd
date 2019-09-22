extends Node

const MAX_NUMBER_SEATS = 350

var win_color


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