extends Room

var door: Node2D
var right_edge: int
const person_y: int = 38

func _ready() -> void:
	door = Nodes.elevator.get_node("Door")
	self.person_limit = 4
	right_edge = get_right_edge()
	person_start_position = Vector2(right_edge, person_y)
	$FloorNum.text = str(get_index() + 1)

func get_person_position(i: int) -> Vector2:
	var spacing: int = Global.person_spacing
	var radius: int = Global.person_radius
	var x = spacing + (spacing + radius * 2) * i
	return Vector2(x, person_y)

func enter_elevator_next():
	if $Persons.get_child_count() > 0:
		var person = $Persons.get_child(0)
		if not person.is_moving() and Nodes.elevator.has_room():
			person.patience_ended.disconnect(_on_person_patience_ended)
			Nodes.elevator.add_person(person)
			update_person_positions()

func set_pressed(is_on: bool) -> void:
	$FloorNumFrame.frame = 1 if is_on else 0

func add_person(person) -> void:
	assert(has_room(), name + " is full")
	$Persons.add_child(person)
	person.position = person_start_position
	super(person)

func get_right_edge() -> int:
	var _right_edge = $TouchScreenButton.position.x
	_right_edge += $TouchScreenButton.shape.size.x / 2
	_right_edge -= Global.person_radius * 2
	return _right_edge

func _on_person_patience_ended(person: Node2D) -> void:
	Nodes.hud.increment_angries(1)
	Nodes.hud.increment_money(-Global.angry_money_loss)
	await remove_person(person, false)
	update_person_positions()

func _on_touched() -> void:
	Nodes.elevator.go_to_floor(get_index() + 1)
