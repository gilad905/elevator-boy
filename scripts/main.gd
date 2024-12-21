extends Node2D

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	_on_persons_timer_timeout()
	$Persons/PersonsTimer.start()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("elevator_move_down"):
		$ElevatorWrap/Elevator.move_one_floor(false)
	elif Input.is_action_pressed("elevator_move_up"):
		$ElevatorWrap/Elevator.move_one_floor(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("elevator_toggle_door"):
		var elevator = $ElevatorWrap/Elevator
		await elevator.toggle_door()
		if elevator.is_door_open:
			elevator.remove_persons_in_dest()
			var current_floor = $Floors.get_floor(elevator.current_floor_num)
			current_floor.enter_elevator_next()

func _on_persons_timer_timeout() -> void:
	$Persons.add_person()
