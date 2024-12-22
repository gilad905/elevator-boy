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

func _on_door_opened():
	$Elevator.remove_persons_in_dest()
	var current_floor = $Floors.get_floor($Elevator.current_floor_num)
	current_floor.enter_elevator_next()

func debug_fill_elevator_with_persons():
	for i in 4:
		var person = $Persons.create_person(i + 1)
		$Elevator.add_person(person)
