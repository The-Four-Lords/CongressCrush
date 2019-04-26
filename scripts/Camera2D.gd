extends Camera2D

onready var screen_kick = $ScreenKick

func camera_effect():
	screen_kick.interpolate_property(self, "zoom", Vector2(0.9, 0.9), Vector2(1, 1), 0.2, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	screen_kick.start()

func move_camera(placement):
	offset = placement

func _on_grid_place_camera(placement):
	move_camera(placement)

func _on_grid_camera_effect():
	camera_effect()