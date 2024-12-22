extends Room

@export var person_enter_interval_sec: float
var in_enter_elevator_loop: bool = false
var elevator: Node2D
var door: Node2D

func _ready() -> void:
	elevator = get_node("/root/Main/Elevator")
	door = elevator.get_node("Door")
	self.person_limit = 9
	$FloorNum.text = str(get_index() + 1)

func add_person(person: Node) -> void:
	super(person)
	if door.current_state == door.State.open:
		enter_elevator_loop()

func get_person_position(i: int) -> Vector2:
	var spacing: int = Global.person_spacing
	var radius: int = Global.person_radius
	var x = spacing + (spacing + radius * 2) * i
	return Vector2(x, 25)

func enter_elevator_loop():
	if not in_enter_elevator_loop:
		print(name + " starting enter_elevator_loop")
		in_enter_elevator_loop = true
		await enter_elevator_tick()
		in_enter_elevator_loop = false

func enter_elevator_tick():
	print(name + " enter_elevator_tick")
	var succeeded = enter_elevator_next()
	if succeeded:
		await get_tree().create_timer(person_enter_interval_sec).timeout
		enter_elevator_tick()

func enter_elevator_next() -> bool:
	var is_door_open = door.current_state == door.State.open
	var can_enter = $Persons.get_child_count() and elevator.has_room() and is_door_open
	if not can_enter:
		return false

	var person = $Persons.get_child(0)
	$Persons.remove_child(person)
	elevator.add_person(person)
	update_person_positions()
	return true

func _on_elevator_opened() -> void:
	enter_elevator_loop()
