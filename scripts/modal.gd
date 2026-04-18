extends ColorRect

signal menu_selected(choice: String)

const ANIM_DURATION: float = 0.4
const SLIDE_OFFSET: float = 200.0
const BUTTON_SCENE: PackedScene = preload("res://scenes/modal_button.tscn")
const BUTTONS: Dictionary = {
	"continue": "CONTINUE",
	"resume_game": "RESUME GAME",
	"new_game": "NEW GAME",
}

var _buttons: Dictionary = {}
var content;
var menu;
var prompt;
var image;
var content_y;

func _ready() -> void:
	hide()

	content = $Content
	prompt = $Content/ColorRect/Prompt
	menu = $Content/ColorRect/MarginContainer/Menu
	image = $Content/ColorRect/MarginContainer/Image
	content_y = content.position.y
	
	self.self_modulate.a = 0
	content.modulate.a = 0
	content.position.y = SLIDE_OFFSET

	for id in BUTTONS:
		var button = BUTTON_SCENE.instantiate()
		button.name = id
		button.text = BUTTONS[id]
		button.visible = false
		button.pressed.connect(_on_button_pressed.bind(id))
		menu.add_child(button)
		_buttons[id] = button

func show_modal(text: String = "", texture: Texture2D = null) -> Signal:
	_set_visible_buttons(["continue"])
	_update_fields(text, texture)

	get_tree().paused = true
	_tween_in()
	return menu_selected

func show_menu(text: String = "", texture: Texture2D = null) -> Signal:
	_set_visible_buttons(["resume_game", "new_game"])
	_buttons["resume_game"].disabled = State.current_level <= 1
	_update_fields(text, texture)

	get_tree().paused = true
	_tween_in()
	return menu_selected

func hide_modal() -> void:
	await _tween_out()
	get_tree().paused = false

func _update_fields(text: String = "", texture: Texture2D = null) -> void:
	prompt.visible = text != ""
	prompt.text = text

	image.visible = texture != null
	if texture:
		image.texture = texture

func _tween_in() -> void:
	show()
	var tween = create_tween().set_parallel(true)
	_tween_property(tween, self , "self_modulate:a", 1.0)
	_tween_property(tween, content, "modulate:a", 1.0)
	_tween_property(tween, content, "position:y", content_y)
	await tween.finished

func _tween_out() -> void:
	var tween = create_tween().set_parallel(true)
	_tween_property(tween, self , "self_modulate:a", 0.0)
	_tween_property(tween, content, "modulate:a", 0.0)
	_tween_property(tween, content, "position:y", SLIDE_OFFSET)
	await tween.finished
	hide()

func _tween_property(tween, target, property, value) -> void:
	tween.tween_property(target, property, value, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _set_visible_buttons(visible_ids: Array) -> void:
	for id in _buttons:
		_buttons[id].visible = id in visible_ids

func _on_button_pressed(button_id: String) -> void:
	await hide_modal()
	menu_selected.emit(button_id)