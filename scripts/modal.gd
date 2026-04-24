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

func show_popup(popup_name, duration, prompt_text = null) -> void:
	var _content = _init_content("popup_" + popup_name, prompt_text)
	var animation = _content.find_child("AnimationPlayer")
	if animation != null:
		animation.play("default")
	get_tree().paused = true
	_tween_in(_content, false)
	await get_tree().create_timer(duration).timeout
	# await _tween_out(_content, false)
	_content.queue_free()
	_content = null
	get_tree().paused = false

func show_modal(modal_name, prompt_text = null) -> Signal:
	# if Env.is_dev:
	# 	print("DEV - Skipping modal")
	# 	get_tree().create_timer(.2).timeout.connect(menu_selected.emit.bind("Continue"))
	# 	return menu_selected
	_init_content(modal_name, prompt_text)
	var menu = content.get_node("ColorRect/MarginContainer/Menu")
	_bind_menu_buttons(menu)
	if menu.has_node("ResumeGame"):
		var resume_button = menu.get_node("ResumeGame")
		resume_button.disabled = State.current_level <= 1
		var cursor = Control.CURSOR_FORBIDDEN if resume_button.disabled else Control.CURSOR_POINTING_HAND
		resume_button.mouse_default_cursor_shape = cursor

	get_tree().paused = true
	_tween_in(content, true)
	return menu_selected

func _init_content(modal_name, prompt_text = null) -> Control:
	content = Settings.modal_meta[modal_name].instantiate()
	self.add_child(content)
	if prompt_text != null:
		content.find_child("Prompt").text = prompt_text

	return content

func _hide_modal() -> void:
	await _tween_out(content, true)
	content.queue_free()
	content = null
	get_tree().paused = false

func _on_button_pressed(button: Button) -> void:
	await _hide_modal()
	menu_selected.emit(button.name)

func _bind_menu_buttons(_menu) -> void:
	for button in _menu.get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))

func _tween_in(_content, slide_up) -> void:
	self.modulate.a = 0
	if slide_up:
		_content.position.y = SLIDE_OFFSET
	show()
	var tween = create_tween().set_parallel(true)
	_tween_property(tween, self , "modulate:a", 1.0)
	if slide_up:
		_tween_property(tween, _content, "position:y", content_y)
	await tween.finished

func _tween_out(_content, slide_up) -> void:
	var tween = create_tween().set_parallel(true)
	_tween_property(tween, self , "modulate:a", 0.0)
	if slide_up:
		_tween_property(tween, _content, "position:y", SLIDE_OFFSET)
	await tween.finished
	hide()

func _tween_property(tween, target, property, value) -> void:
	tween.tween_property(target, property, value, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
