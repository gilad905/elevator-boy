extends ColorRect

signal menu_selected(choice: String)

const ANIM_DURATION: float = 0.4
const SLIDE_OFFSET: float = 200.0
const BUTTON_SCENE: PackedScene = preload("res://scenes/modals/modal_button.tscn")
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
var custom_content;

func _ready() -> void:
	hide()

	content = $Content
	prompt = $Content/ColorRect/Prompt
	image = $Content/ColorRect/Image
	menu = $Content/ColorRect/MarginContainer/Menu
	content_y = content.position.y
	
	prompt.text = ""
	image.texture = null

	for _name in BUTTONS:
		var button = BUTTON_SCENE.instantiate()
		button.name = _name
		button.text = BUTTONS[_name]
		button.visible = false
		button.pressed.connect(_on_button_pressed.bind(_name))
		menu.add_child(button)
		buttons[_name] = button

func show_modal(modal_meta: Dictionary) -> Signal:
	if "content" in modal_meta:
		_attach_custom_content(modal_meta)
		_show()
	else:
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

func _show(text: String = "", texture: Texture2D = null) -> void:
	_update_fields(text, texture)
	# if Env.is_dev:
	# 	print("DEV - Skipping modal")
	# 	get_tree().create_timer(.2).timeout.connect(menu_selected.emit.bind("continue"))
	# else:
	# print("pausing")
	get_tree().paused = true
	_tween_in()

func hide_modal() -> void:
	await _tween_out()
	if custom_content:
		custom_content.queue_free()
		custom_content = null
		content = $Content
		content.show()
	# print("unpausing")
	get_tree().paused = false

func _attach_custom_content(modal_meta: Dictionary) -> void:
	var scene: PackedScene = modal_meta["content"]
	custom_content = scene.instantiate()
	content.hide()
	self.add_child(custom_content)
	content = custom_content
	for button in content.find_child("Menu").get_children():
		button.pressed.connect(_on_button_pressed.bind(button.name))

func _update_fields(text: String = "", texture: Texture2D = null) -> void:
	prompt.visible = text != ""
	prompt.text = text

	image.visible = texture != null
	if texture:
		image.texture = texture

func _tween_in() -> void:
	self.self_modulate.a = 0
	content.modulate.a = 0
	content.position.y = SLIDE_OFFSET

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
	# print("tweened out")
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