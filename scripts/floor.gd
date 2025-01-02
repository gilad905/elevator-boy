extends Room

var floors: Node
var elevator: Node2D
var door: Node2D
var right_edge: int
const person_y: int = 38

func _ready() -> void:
	super()
	floors = get_node("/root/Main/Floors")
	elevator = get_node("/root/Main/Elevator")
	door = elevator.get_node("Door")
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
	var person = $Persons.get_child(0)
	if person and not person.is_moving() and elevator.has_room():
		person.patience_ended.disconnect(_on_person_patience_ended)
		elevator.add_person(person)
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
	hud.increment_angries(1)
	hud.increment_money(-Global.angry_money_loss)
	await remove_person(person, false)
	update_person_positions()

func _on_touched() -> void:
	elevator.go_to_floor(get_index() + 1)
