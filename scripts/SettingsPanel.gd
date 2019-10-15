extends "res://scripts/BaseMenuPanel.gd"

signal sound_change
signal back_pressed

#var sound_enable = true

func _ready():
	$MarginContainer/GraphicAndButtons/Buttons/Button1.set_pressed(!SoundManager.sound_enable)

func _on_Button1_pressed():
	SoundManager.play_fixed_sound(0)
	SoundManager.sound_enable = !SoundManager.sound_enable
	SoundManager.enable_game_sound(SoundManager.sound_enable)

func _on_Button2_pressed():
	SoundManager.play_fixed_sound(0)
	emit_signal("back_pressed")

# Difficulty selection (FIXME: a better implement option must exist)
func _on_EasyButton_pressed():
	Utils.global_piece_value = Utils.GLOBAL_PIECE_VALUES_ACCORDING_LEVEL[0]
	pass

func _on_MediumButton_pressed():
	Utils.global_piece_value = Utils.GLOBAL_PIECE_VALUES_ACCORDING_LEVEL[1]
	pass
	
func _on_HardButton_pressed():
	Utils.global_piece_value = Utils.GLOBAL_PIECE_VALUES_ACCORDING_LEVEL[2]
	pass