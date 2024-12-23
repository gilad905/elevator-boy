extends Room

var elevator: Node2D
var door: Node2D

func _ready() -> void:
	elevator = get_node("/root/Main/Elevator")
	door = elevator.get_node("Door")
	self.person_limit = 9
	$FloorNum.text = str(get_index() + 1)

func get_person_position(i: int) -> Vector2:
	var spacing: int = Global.person_spacing
	var radius: int = Global.person_radius
	var x = spacing + (spacing + radius * 2) * i
	return Vector2(x, 25)

func enter_elevator_next():
	if $Persons.get_child_count() and elevator.has_room():
		var person = $Persons.get_child(0)
		$Persons.remove_child(person)
		elevator.add_person(person)
		update_person_positions()

func _on_person_timeout_reached(person: Node2D) -> void:
	$Persons.remove_child(person)
	update_person_positions()
