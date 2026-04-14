extends ColorRect

signal continue_pressed

const ANIM_DURATION: float = 0.5
const SLIDE_OFFSET: float = 800.0

func show_modal(text: String = "", texture: Texture2D = null, show_continue: bool = true) -> void:
	get_tree().paused = true

	var prompt = $Content/VBox/Prompt
	var image = $Content/VBox/Image
	var continue_btn = $Content/VBox/Continue

	prompt.visible = text != ""
	prompt.text = text

	image.visible = texture != null
	if texture:
		image.texture = texture

	continue_btn.visible = show_continue

	modulate.a = 0
	$Content.position.y = SLIDE_OFFSET
	show()

	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, ANIM_DURATION)
	tween.tween_property($Content, "position:y", 0.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func hide_modal() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, ANIM_DURATION)
	tween.tween_property($Content, "position:y", SLIDE_OFFSET, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	hide()

func _on_continue_pressed() -> void:
	continue_pressed.emit()
