extends Node

func play_sound(sound_name: String) -> void:
	var player = $Sounds.find_child(sound_name)
	player.play()
	await player.finished

func play_music(music_name: String) -> void:
	var player = $Music.find_child(music_name)
	player.play()
