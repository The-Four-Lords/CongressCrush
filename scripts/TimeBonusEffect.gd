extends Node2D

const ANIMATION_TIME = 1

func setup(bonus):
	$EffectLabel.text = "+" + String(bonus)
	animate_position()
	#animate_scale()

func _process(delta):
	remove_text()
	pass

func remove_text():
	if !$TweenPosition.is_active():
		$EffectLabel.text = ""

func animate_position():
	var iniPos = $EffectLabel.rect_position
	var endPos = Vector2(iniPos.x, iniPos.y - 100)
	$TweenPosition.interpolate_property($EffectLabel, 'rect_position', iniPos, endPos, ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_OUT)
	$TweenPosition.start()
	
func animate_scale():
	$TweenScale.interpolate_property($EffectLabel, 'rect_scale', Vector2(0.1,0.1), Vector2(1,1), ANIMATION_TIME, Tween.TRANS_SINE, Tween.EASE_OUT)
	$TweenScale.start()
	pass