extends MarginContainer

signal continue_pressed

const ANIM_DURATION: float = 0.4
const SLIDE_OFFSET: float = 200.0

func _ready() -> void:
	hide()

func show_modal(text: String = "", texture: Texture2D = null) -> Signal:
	get_tree().paused = true

	var prompt = $Content/Prompt
	var image = $Content/Image

	prompt.visible = text != ""
	prompt.text = text

	image.visible = texture != null
	if texture:
		image.texture = texture

	modulate.a = 0
	self.position.y = SLIDE_OFFSET
	show()

	var tween = create_tween().set_parallel(true)
	tween.tween_property(self , "modulate:a", 1.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 0.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	return continue_pressed

func hide_modal() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self , "modulate:a", 0.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", SLIDE_OFFSET, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	hide()

func _on_continue_pressed() -> void:
	await hide_modal()
	get_tree().paused = false
	continue_pressed.emit()
