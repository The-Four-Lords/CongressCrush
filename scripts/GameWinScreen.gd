extends "res://scripts/BaseMenuPanel.gd"

onready var win_panel_texture = $MarginContainer/TextureRect

func _on_ContinueButton_pressed():
	get_tree().reload_current_scene()

func _on_GoalHolder_game_won():
	var img = Image.new()
	var image_texture = ImageTexture.new()
	img.load("res://art/UI/Panels/Win_Panel.png")
	image_texture.create_from_image(img)
	win_panel_texture.texture = image_texture
	slide_in()