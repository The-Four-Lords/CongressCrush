extends "res://scripts/BaseMenuPanel.gd"

onready var win_panel_texture = $MarginContainer/TextureRect

var win_panels = {
"blue" : "res://art/UI/Panels/WinPanels/blue.png",
"red" :  "res://art/UI/Panels/WinPanels/red.png",
"green" :  "res://art/UI/Panels/WinPanels/green.png",
"orange" :  "res://art/UI/Panels/WinPanels/orange.png",
"purple":  "res://art/UI/Panels/WinPanels/purple.png",
"yellow" :  "res://art/UI/Panels/WinPanels/yellow.png",
"lose" :  "res://art/UI/Panels/WinPanels/lose.png",
"draw" :  "res://art/UI/Panels/WinPanels/draw.png"
}

func _on_ContinueButton_pressed():
	get_tree().reload_current_scene()

func _on_GoalHolder_game_won():
	#print("DEBUG panel_color:",Utils.win_color)
	var stream_texture = load(win_panels[Utils.win_color])
	var image_texture = ImageTexture.new()
	var image = Image.new()
	image = stream_texture.get_data()
	image.lock()
	image_texture.create_from_image(image, 0)
	win_panel_texture.texture = image_texture
	slide_in()
	SoundManager.disable_sounds(false)
	SoundManager.play_win_music(Utils.win_color)

func _on_QuitButt_pressed():
	#SoundManager.disable_sounds(false)
	SoundManager.disable_sounds(true)
	SoundManager.stop_win_music_player()
	get_tree().change_scene("res://scenes/GameMenu.tscn")

func _on_Continue_pressed():
	SoundManager.stop_win_music_player()
	get_tree().reload_current_scene()
