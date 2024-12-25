extends Room

var floors: Node
var elevator: Node2D
var door: Node2D
var unpressed_forground: Color
var pressed_forground: Color
var unpressed_stylebox: StyleBoxTexture
var pressed_stylebox: StyleBoxTexture
var right_edge: int
const person_y: int = 25

func _ready() -> void:
	floors = get_node("/root/Main/Floors")
	elevator = get_node("/root/Main/Elevator")
	door = elevator.get_node("Door")
	self.person_limit = 9
	unpressed_forground = $FloorNum.get_theme_color("font_color")
	pressed_forground = floors.pressed_forground
	unpressed_stylebox = $FloorNum.get_theme_stylebox("normal")
	pressed_stylebox = preload("res://resources/floor_num_pressed.tres")
	right_edge = $TouchScreenButton.position.x
	right_edge += $TouchScreenButton.shape.size.x / 2
	right_edge += Global.person_radius * 2
	$FloorNum.text = str(get_index() + 1)

func add_person(person) -> void:
	assert(has_room(), name + " is full")
	$Persons.add_child(person)
	person.position = Vector2(right_edge, person_y)
	super(person)

func get_person_position(i: int) -> Vector2:
	var spacing: int = Global.person_spacing
	var radius: int = Global.person_radius
	var x = spacing + (spacing + radius * 2) * i
	return Vector2(x, person_y)

func enter_elevator_next():
	var person = $Persons.get_child(0)
	if person and not person.is_moving and elevator.has_room():
		person.patience_ended.disconnect(_on_person_patience_ended)
		person.reparent(elevator.get_node("Persons"))
		elevator.add_person(person)
		update_person_positions()

func set_pressed(is_on: bool) -> void:
	var forground = pressed_forground if is_on else unpressed_forground
	var stylebox = pressed_stylebox if is_on else unpressed_stylebox
	$FloorNum.add_theme_color_override("font_color", forground)
	$FloorNum.add_theme_stylebox_override("normal", stylebox)

func _on_person_patience_ended(person: Node2D) -> void:
	await person.show_patience_ended(false).finished
	update_person_positions()
	get_node("/root/Main/HUD").increment_money(false)

func _on_touched() -> void:
	elevator.go_to_floor(get_index() + 1)
