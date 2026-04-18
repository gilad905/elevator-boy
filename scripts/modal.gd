extends MarginContainer

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
var menu;
var prompt;
var image;

func _ready() -> void:
	menu = $Content/MarginContainer/Menu
	prompt = $Content/Prompt
	image = $Content/MarginContainer/Image

	for id in BUTTONS:
		var button = BUTTON_SCENE.instantiate()
		button.name = id
		button.text = BUTTONS[id]
		button.visible = false
		button.pressed.connect(_on_button_pressed.bind(id))
		menu.add_child(button)
		_buttons[id] = button
	hide()

func _show(text: String = "", texture: Texture2D = null) -> void:
	get_tree().paused = true

	prompt.visible = text != ""
	prompt.text = text

	image.visible = texture != null
	if texture:
		image.texture = texture

	self.modulate.a = 0
	self.position.y = SLIDE_OFFSET
	show()

	var tween = create_tween().set_parallel(true)
	tween.tween_property(self , "modulate:a", 1.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self , "position:y", 0.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await Nodes.Foreground.show_foreground()

func show_modal(text: String = "", texture: Texture2D = null) -> Signal:
	_set_visible_buttons(["continue"])
	_show(text, texture)
	return menu_selected

func show_menu(text: String = "", texture: Texture2D = null) -> Signal:
	_set_visible_buttons(["resume_game", "new_game"])
	_buttons["resume_game"].disabled = State.current_level <= 1
	_show(text, texture)
	return menu_selected

func hide_modal() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self , "modulate:a", 0.0, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self , "position:y", SLIDE_OFFSET, ANIM_DURATION) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await Nodes.Foreground.hide_foreground()
	hide()

func _set_visible_buttons(visible_ids: Array) -> void:
	for id in _buttons:
		_buttons[id].visible = id in visible_ids

func _on_button_pressed(button_id: String) -> void:
	await hide_modal()
	get_tree().paused = false
	menu_selected.emit(button_id)
