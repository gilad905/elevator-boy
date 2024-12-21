extends Node2D

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	_on_persons_timer_timeout()
	$Persons/PersonsTimer.start()

func _on_persons_timer_timeout() -> void:
	$Persons.add_person()
