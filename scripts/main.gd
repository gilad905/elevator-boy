extends Node2D

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	_on_persons_timer_timeout()
	$Persons/PersonsTimer.start()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("elevator_move_up"):
		$Elevator.move_one_floor(true)
	elif Input.is_action_pressed("elevator_move_down"):
		$Elevator.move_one_floor(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()

func _on_persons_timer_timeout() -> void:
	$Persons.add_random_person()

func _on_door_state_changed(state: int) -> void:
	if state == $Door.State.open:
		$Elevator.remove_persons_in_dest()
		$ElevatorEnterTimer.start()
	elif state == $Door.State.closing:
		$ElevatorEnterTimer.stop()
