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
	var img = Image.new()
	var image_texture = ImageTexture.new()
	img.load(win_panels[Utils.win_color])
	image_texture.create_from_image(img)
	win_panel_texture.texture = image_texture
	slide_in()
	SoundManager.disable_sounds(false)
	SoundManager.play_win_music(Utils.win_color)