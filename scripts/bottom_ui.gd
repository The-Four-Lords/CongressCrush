extends TextureRect

signal pause_game
var effectsOn = true
var musicOn = true

onready var counter_label = $MarginContainer/HBoxContainer/VBoxContainer/CounterLabel
var current_counter = 0

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_grid_update_counter(new_value = -1):
	if(Utils.counter_label_node == null): Utils.counter_label_node = $MarginContainer/HBoxContainer/VBoxContainer/Sprite
	current_counter += new_value
	if current_counter > 99: current_counter = 99 #time_bonus control
	if current_counter < 10: #2digits panel control
		var number_fixed_2_digits = "0" + String(current_counter)
		counter_label.text = number_fixed_2_digits
	else: 
		counter_label.text = String(current_counter)

func _on_Reset_pressed():	
	SoundManager.stop_combo_sound()
	get_tree().reload_current_scene()

func _on_TextureButton2_pressed():
	#print("DEBUG - effectsOn:", effectsOn)
	SoundManager.activate_effects(!effectsOn)
	effectsOn = !effectsOn

func _on_TextureButton3_pressed():
	#print("DEBUG - musicOn:", musicOn)
	SoundManager.activate_music(!musicOn)
	musicOn = !musicOn
