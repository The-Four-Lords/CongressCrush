extends "res://scripts/BaseMenuPanel.gd"

onready var win_panel_texture = $MarginContainer/TextureRect

var win_panels = {
"blue" : preload("res://art/UI/Panels/WinPanels/blue.png"),
"red" :  preload("res://art/UI/Panels/WinPanels/red.png"),
"green" :  preload("res://art/UI/Panels/WinPanels/green.png"),
"orange" :  preload("res://art/UI/Panels/WinPanels/orange.png"),
"purple":  preload("res://art/UI/Panels/WinPanels/purple.png"),
"yellow" :  preload("res://art/UI/Panels/WinPanels/yellow.png"),
"lose" :  preload("res://art/UI/Panels/WinPanels/lose.png"),
"draw" :  preload("res://art/UI/Panels/WinPanels/draw.png")
}

func _on_ContinueButton_pressed():
	get_tree().reload_current_scene()

func _on_GoalHolder_game_won():
	#print("DEBUG panel_color:",Utils.win_color)
	var stream_texture = win_panels[Utils.win_color]
	var image_texture = ImageTexture.new()
	var image = Image.new()
	image = stream_texture.get_data()
	image.lock()
	image_texture.create_from_image(image, 0)
	win_panel_texture.texture = image_texture
	slide_in()
	SoundManager.enable_sounds(false)
	SoundManager.play_win_music(Utils.win_color)
	SoundManager.remove_combo_audio()

func _on_QuitButt_pressed():
	SoundManager.enable_sounds(true)
	SoundManager.stop_win_music_player()
	get_tree().change_scene("res://scenes/GameMenu.tscn")

func _on_Continue_pressed():
	SoundManager.stop_win_music_player()
	get_tree().reload_current_scene()
