extends MarginContainer

signal continue_pressed
signal menu_selected(choice: String)

const ANIM_DURATION: float = 0.4
const SLIDE_OFFSET: float = 200.0

func _ready() -> void:
	hide()

func _show(text: String = "", texture: Texture2D = null) -> void:
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

func show_modal(text: String = "", texture: Texture2D = null) -> Signal:
	$Content/Continue.visible = true
	$Content/Menu.visible = false
	_show(text, texture)
	return continue_pressed

func show_menu(text: String = "", texture: Texture2D = null) -> Signal:
	$Content/Continue.visible = false
	$Content/Menu.visible = true
	$Content/Menu/ResumeGame.disabled = State.current_level <= 1
	_show(text, texture)
	return menu_selected

func hide_modal() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self , "modulate:a", 0.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", SLIDE_OFFSET, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	hide()

func _on_button_pressed(caller: Control) -> void:
	var button_name = caller.name
	await hide_modal()
	get_tree().paused = false
	menu_selected.emit(button_name)
