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

var buttons: Dictionary = {}
var content;
var menu;
var prompt;
var image;
var content_y;

func _ready() -> void:
	hide()

	content = $Content
	prompt = $Content/ColorRect/Prompt
	image = $Content/ColorRect/Image
	menu = $Content/ColorRect/MarginContainer/Menu
	content_y = content.position.y
	
	self.self_modulate.a = 0
	content.modulate.a = 0
	content.position.y = SLIDE_OFFSET
	prompt.text = ""
	image.texture = null

	for id in BUTTONS:
		var button = BUTTON_SCENE.instantiate()
		button.name = id
		button.text = BUTTONS[id]
		button.visible = false
		button.pressed.connect(_on_button_pressed.bind(id))
		menu.add_child(button)
		buttons[id] = button

func show_modal(modal_meta: Dictionary) -> Signal:
	var button_ids = modal_meta["buttons"] if "buttons" in modal_meta else ["continue"]
	_set_visible_buttons(button_ids)
	if "resume_game" in button_ids:
		buttons["resume_game"].disabled = State.current_level <= 1
	var text = modal_meta["text"] if "text" in modal_meta else ""
	var texture = modal_meta["texture"] if "texture" in modal_meta else null
	_show(text, texture)
	return menu_selected

func show_dynamic(text: String = "", texture: Texture2D = null) -> Signal:
	_set_visible_buttons(["continue"])
	_show(text, texture)
	return menu_selected

func _show(text, texture) -> void:
	_update_fields(text, texture)
	# if Env.is_dev:
	# 	print("DEV - Skipping modal")
	# 	get_tree().create_timer(.2).timeout.connect(menu_selected.emit.bind("continue"))
	# else:
	get_tree().paused = true
	_tween_in()

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
	for id in buttons:
		buttons[id].visible = id in visible_ids

func _on_button_pressed(button_id: String) -> void:
	await hide_modal()
	menu_selected.emit(button_id)