extends Node

func play_sound(sound_name: String) -> void:
	var player = find_child(sound_name)
	player.play()
	await player.finished
