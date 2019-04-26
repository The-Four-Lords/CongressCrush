extends "res://scripts/BaseMenuPanel.gd"

signal play_pressed
signal settings_pressed

func _on_Button1_pressed():
	SoundManager.play_fixed_sound(0)
	emit_signal("play_pressed")

func _on_Button2_pressed():
	SoundManager.play_fixed_sound(0)
	emit_signal("settings_pressed")