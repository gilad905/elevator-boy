extends Node2D

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	_on_persons_timer_timeout()
	$Persons/PersonsTimer.start()

func _input(event) -> void:
	if event.is_action_pressed("elevator_move_down"):
		$ElevatorWrap/Elevator.move_one_floor(false)
	elif event.is_action_pressed("elevator_move_up"):
		$ElevatorWrap/Elevator.move_one_floor(true)

func _on_persons_timer_timeout() -> void:
	$Persons.add_person()
