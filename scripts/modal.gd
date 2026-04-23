extends ColorRect

signal menu_selected(choice: String)

const ANIM_DURATION: float = 0.4
const SLIDE_OFFSET: float = 200.0

var content;
var content_y;

func _ready() -> void:
	content_y = $Content.position.y
	$Content.queue_free()
	hide()

func show_modal(modal_name, prompt_text = null) -> Signal:
	# if Env.is_dev:
	# 	print("DEV - Skipping modal")
	# 	get_tree().create_timer(.2).timeout.connect(menu_selected.emit.bind("Continue"))
	# 	return menu_selected

	content = Settings.modal_meta[modal_name].instantiate()
	self.add_child(content)
	if prompt_text != null:
		content.get_node("ColorRect/Prompt").text = prompt_text

	var menu = content.get_node("ColorRect/MarginContainer/Menu")
	_bind_menu_buttons(menu)
	if menu.has_node("ResumeGame"):
		var resume_button = menu.get_node("ResumeGame")
		resume_button.disabled = State.current_level <= 1
		resume_button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN if resume_button.disabled else Control.CURSOR_POINTING_HAND

	get_tree().paused = true
	_tween_in(content)

	return menu_selected

func hide_modal() -> void:
	await _tween_out(content)
	content.queue_free()
	content = null
	get_tree().paused = false

func _on_button_pressed(button: Button) -> void:
	await hide_modal()
	menu_selected.emit(button.name)

func _bind_menu_buttons(_menu) -> void:
	for button in _menu.get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))

func _tween_in(_content) -> void:
	self.self_modulate.a = 0
	_content.modulate.a = 0
	_content.position.y = SLIDE_OFFSET

	show()
	var tween = create_tween().set_parallel(true)
	_tween_property(tween, self , "self_modulate:a", 1.0)
	_tween_property(tween, _content, "modulate:a", 1.0)
	_tween_property(tween, _content, "position:y", content_y)
	await tween.finished

func _tween_out(_content) -> void:
	var tween = create_tween().set_parallel(true)
	_tween_property(tween, self , "self_modulate:a", 0.0)
	_tween_property(tween, _content, "modulate:a", 0.0)
	_tween_property(tween, _content, "position:y", SLIDE_OFFSET)
	await tween.finished
	# print("tweened out")
	hide()

func _tween_property(tween, target, property, value) -> void:
	tween.tween_property(target, property, value, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
