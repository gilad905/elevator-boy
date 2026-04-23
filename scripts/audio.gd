extends Node

var current_music: AudioStreamPlayer

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
