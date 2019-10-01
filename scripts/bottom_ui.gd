extends TextureRect

signal pause_game

onready var counter_label = $MarginContainer/HBoxContainer/VBoxContainer/CounterLabel
var current_counter = 0

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_grid_update_counter(new_value = -1):	
	current_counter += new_value
	#print("DEBUG - ", current_counter)
	if current_counter < 10:
		var number_fixed_2_digits = "0" + String(current_counter)
		counter_label.text = number_fixed_2_digits
	else: 
		counter_label.text = String(current_counter)