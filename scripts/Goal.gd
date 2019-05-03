extends Node

# Goal Information
export (String) var goal_display_name
export (Texture) var goal_texture
export (int) var max_needed
export (String) var goal_target
var number_collected = 0
var goal_met = false

func check_goal(goal_type):
	if goal_type == goal_target:
		update_goal()

func update_goal():
	if number_collected < max_needed:
		number_collected += 1
	if number_collected == max_needed:
		if !goal_met: goal_met = true