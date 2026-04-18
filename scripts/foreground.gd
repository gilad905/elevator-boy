extends ColorRect

func show_foreground() -> void:
	show()

	self.self_modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self , "self_modulate:a", 1.0, 0.5) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	
func hide_foreground() -> void:
	var tween = create_tween()
	tween.tween_property(self , "self_modulate:a", 0.0, 0.5) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished

	hide()
