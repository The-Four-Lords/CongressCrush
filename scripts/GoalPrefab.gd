extends TextureRect

var current_number = 0
var max_value
var goal_target = ""
var goal_texture
onready var goal_label = $VBoxContainer2/Name
onready var goal_score = $VBoxContainer2/Score
onready var this_texture = $VBoxContainer/TextureRect

func set_goal_values(goal):
	goal_label.text = goal.goal_display_name
	this_texture.texture = goal.goal_texture
	max_value = goal.max_needed
	goal_target = goal.goal_target
	goal_score.text = String(current_number)

func update_goal_values(goal_type):
	if goal_type == goal_target:
		current_number += Utils.global_piece_value
		Utils.CURRENT_SEAT_COUNT += Utils.global_piece_value
		if Utils.CURRENT_SEAT_COUNT <= Utils.MAX_NUMBER_SEATS:
			goal_score.text = String(current_number)
		else:
			goal_score.text = String(current_number + (Utils.MAX_NUMBER_SEATS - Utils.CURRENT_SEAT_COUNT))