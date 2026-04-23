extends ColorRect

signal menu_selected(choice: String)
signal audio_toggled(audio_type: String, is_on: bool)

const ANIM_DURATION: float = 0.4
const SLIDE_OFFSET: float = 200.0

var content;
var menu;
var prompt;
var image;
var content_y;
var custom_content;
var audio_icons = {
	"sounds_on": preload("res://assets/images/audio/sounds-on.png"),
	"sounds_off": preload("res://assets/images/audio/sounds-off.png"),
	"music_on": preload("res://assets/images/audio/music-on.png"),
	"music_off": preload("res://assets/images/audio/music-off.png"),
}

func _ready() -> void:
	hide()
	_set_nodes($Content)
	content_y = content.position.y
	prompt.text = ""
	image.texture = null
	_init_audio_buttons()
	_bind_menu_buttons()

func _init_audio_buttons() -> void:
	var sounds = menu.get_node("Audio/Sounds")
	var music = menu.get_node("Audio/Music")
	_set_audio_by_state(sounds)
	_set_audio_by_state(music)
	sounds.pressed.connect(_on_audio_pressed.bind(sounds))
	music.pressed.connect(_on_audio_pressed.bind(music))

func _set_audio_by_state(button) -> void:
	var is_on = State.sounds_on if button.name == "Sounds" else State.music_on
	var icon_prefix = button.name.to_lower()
	var icon_name = icon_prefix + ("_on" if is_on else "_off")
	button.icon = audio_icons[icon_name]

func _set_nodes(_content) -> void:
	content = _content
	prompt = content.get_node("ColorRect/Prompt")
	image = content.get_node("ColorRect/Image")
	menu = content.get_node("ColorRect/MarginContainer/Menu")

func show_modal(modal_meta: Dictionary) -> Signal:
	if "content" in modal_meta:
		_attach_custom_content(modal_meta)
		_show()
	else:
		var button_names = modal_meta["buttons"] if "buttons" in modal_meta else ["Continue"]
		_set_visible_buttons(button_names)
		var resume_button = menu.get_node("ResumeGame")
		resume_button.disabled = State.current_level <= 1
		resume_button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN if resume_button.disabled else Control.CURSOR_POINTING_HAND
		var text = modal_meta["text"] if "text" in modal_meta else ""
		var texture = modal_meta["texture"] if "texture" in modal_meta else null
		_show(text, texture)
	return menu_selected

func show_dynamic(text: String = "", texture: Texture2D = null) -> Signal:
	_set_visible_buttons(["Continue"])
	_show(text, texture)
	return menu_selected

func _show(text: String = "", texture: Texture2D = null) -> void:
	_update_fields(text, texture)
	# if Env.is_dev:
	# 	print("DEV - Skipping modal")
	# 	get_tree().create_timer(.2).timeout.connect(menu_selected.emit.bind("Continue"))
	# else:
	get_tree().paused = true
	_tween_in()

func hide_modal() -> void:
	await _tween_out()
	if custom_content:
		custom_content.queue_free()
		custom_content = null
		_set_nodes($Content)
		content.show()
	get_tree().paused = false

func _attach_custom_content(modal_meta: Dictionary) -> void:
	var scene: PackedScene = modal_meta["content"]
	custom_content = scene.instantiate()
	content.hide()
	self.add_child(custom_content)
	_set_nodes(custom_content)
	_bind_menu_buttons()

func _bind_menu_buttons() -> void:
	for button in menu.get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))

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

func _on_button_pressed(button: Button) -> void:
	await hide_modal()
	menu_selected.emit(button.name)

func _on_audio_pressed(button: Button) -> void:
	match button.name:
		"Sounds":
			State.sounds_on = not State.sounds_on
			_set_audio_by_state(menu.get_node("Audio/Sounds"))
			audio_toggled.emit("Sounds", State.sounds_on)
		"Music":
			State.music_on = not State.music_on
			_set_audio_by_state(menu.get_node("Audio/Music"))
			audio_toggled.emit("Music", State.music_on)
	State.save()
