extends Node2D

const ANIMATION_TIME = 2

func setup(message):
	$RegenerationMessage.text = message
	print("setup message:",message)
	animate_position()

func _process(delta):
	remove_text()
	pass

func remove_text():
	if !$TweenPosition.is_active():
		$RegenerationMessage.text = ""

func animate_position():
	var iniPos = $RegenerationMessage.rect_position
	var endPos = Vector2(iniPos.x, iniPos.y + 350)
	$TweenPosition.interpolate_property($RegenerationMessage, 'rect_position', iniPos, endPos, ANIMATION_TIME, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$TweenPosition.start()