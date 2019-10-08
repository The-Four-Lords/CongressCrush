extends Node2D

onready var this_sprite = $Sprite
onready var size_tween = $SizeTween
var animation_time = 2

func Setup(new_sprite):
	this_sprite.texture = new_sprite
	slowly_larger()

func slowly_larger():
	size_tween.interpolate_property(this_sprite, "scale", Vector2(0.5, 0.5), Vector2(1, 1), animation_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	size_tween.start()

func _on_SizeTween_tween_completed(object, key):
	slowly_larger()
