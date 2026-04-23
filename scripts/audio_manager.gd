extends Node

var current_music: AudioStreamPlayer
var sounds_button
var music_button

var icons = {
	"sounds_on": preload("res://assets/images/icons/sounds-on.png"),
	"sounds_off": preload("res://assets/images/icons/sounds-off.png"),
	"music_on": preload("res://assets/images/icons/music-on.png"),
	"music_off": preload("res://assets/images/icons/music-off.png"),
}

func _ready() -> void:
	sounds_button = Nodes.HUD.get_node("Buttons/Sounds")
	music_button = Nodes.HUD.get_node("Buttons/Music")
	_set_audio_by_state(sounds_button)
	_set_audio_by_state(music_button)

func play_sound(sound_name: String) -> void:
	if not State.sounds_on:
		return
	var player = $Sounds.find_child(sound_name)
	player.play()
	await player.finished

func play_music(music_name: String) -> void:
	if not State.music_on:
		return
	var player = $Music.find_child(music_name)
	player.play()
	current_music = player

func stop_music() -> void:
	if current_music != null:
		current_music.stop()
		current_music = null

func _set_audio_by_state(button) -> void:
	var is_on = State.sounds_on if button.name == "Sounds" else State.music_on
	var icon_prefix = button.name.to_lower()
	var icon_name = icon_prefix + ("_on" if is_on else "_off")
	button.icon = icons[icon_name]

func _on_sounds_pressed() -> void:
	State.sounds_on = not State.sounds_on
	State.save()
	_set_audio_by_state(sounds_button)

func _on_music_pressed() -> void:
	State.music_on = not State.music_on
	State.save()
	_set_audio_by_state(music_button)
	if State.music_on:
		play_music("Bossa-radio-1")
	else:
		stop_music()
