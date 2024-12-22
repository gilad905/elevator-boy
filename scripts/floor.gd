extends Room

func _ready() -> void:
	self.person_limit = 9
	$FloorNum.text = str(get_index() + 1)

func enter_elevator_next() -> void:
	var elevator = get_node("/root/Main/Elevator")
	if not $Persons.get_child_count() or not elevator.has_room():
		return

	var person = $Persons.get_child(0)
	$Persons.remove_child(person)
	elevator.add_person(person)
	update_person_positions()

func get_person_position(i: int) -> Vector2:
	var spacing: int = Global.person_spacing
	var radius: int = Global.person_radius
	var x = spacing + (spacing + radius * 2) * i
	return Vector2(x, 25)
