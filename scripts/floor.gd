class_name Floor extends Area2D

func _ready() -> void:
	$FloorNum.text = str(get_index() + 1)

func add_person(person) -> void:
	$Persons.add_child(person)
	var i = person.get_index()
	var _position = get_person_position(i)
	person.position = _position

func get_person_position(i: int) -> Vector2:
	var spacing = Global.person_spacing
	var radius = Global.person_radius
	var x = spacing + (spacing + radius * 2) * i
	return Vector2(x, 25)

func enter_elevator_next() -> void:
	if $Persons.get_child_count() == 0:
		return

	var person = $Persons.get_child(0)
	$Persons.remove_child(person)
	var elevator = get_node("/root/Main/ElevatorWrap/Elevator")
	elevator.add_person(person)
