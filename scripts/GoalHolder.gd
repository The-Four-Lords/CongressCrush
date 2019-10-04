extends Node

signal create_goal
signal game_won


var seats = []

func _ready():
	create_goals()

func create_goals():
	for i in get_child_count():
		var current_goal = get_child(i)
		emit_signal("create_goal", current_goal)

func check_goals(goal_type):
	for i in get_child_count():
		get_child(i).check_goal(goal_type)
	check_game_win()

func goals_met():
	for i in get_child_count():
		if !get_child(i).goal_met: return false
	return true

func global_goal_met():
	var num_seats = 0
	#print("\n")
	for i in get_child_count():
		num_seats += get_child(i).number_collected
	return num_seats >= Utils.MAX_NUMBER_SEATS

func check_game_win():
	if global_goal_met():
		if !Utils.GAME_ALREADY_END: 
			Utils.GAME_ALREADY_END = true
			emit_signal("game_won")
			#print("==== WIN ====")

func _on_grid_check_goal(goal_type):
	check_goals(goal_type)

func _on_ice_holder_break_ice(goal_type):
	check_goals(goal_type)
