extends "res://scripts/BaseMenuPanel.gd"

func _on_QuitButton_pressed():
	SoundManager.stop_win_music_player()
	get_tree().change_scene("res://scenes/GameMenu.tscn")

func _on_RestartButton_pressed():
	SoundManager.stop_win_music_player()
	get_tree().reload_current_scene()

func _on_grid_game_over():
	#print("DEBUG - game_over")
	SoundManager.enable_sounds(false)
	SoundManager.play_win_music("lose")
	SoundManager.remove_combo_audio()
	slide_in()