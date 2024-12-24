extends Room

var floors: Node
var elevator: Node2D
var door: Node2D
var unpressed_forground: Color
var pressed_forground: Color
var unpressed_stylebox: StyleBoxTexture
var pressed_stylebox: StyleBoxTexture

func _ready() -> void:
	floors = get_node("/root/Main/Floors")
	elevator = get_node("/root/Main/Elevator")
	door = elevator.get_node("Door")
	self.person_limit = 9
	unpressed_forground = $FloorNum.get_theme_color("font_color")
	pressed_forground = floors.pressed_forground
	unpressed_stylebox = $FloorNum.get_theme_stylebox("normal")
	pressed_stylebox = preload("res://resources/floor_num_pressed.tres")
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

func set_pressed(is_on: bool) -> void:
	var forground = pressed_forground if is_on else unpressed_forground
	var stylebox = pressed_stylebox if is_on else unpressed_stylebox
	$FloorNum.add_theme_color_override("font_color", forground)
	$FloorNum.add_theme_stylebox_override("normal", stylebox)

func _on_person_timeout_reached(person: Node2D) -> void:
	$Persons.remove_child(person)
	update_person_positions()

func _on_touched() -> void:
	elevator.go_to_floor(get_index() + 1)
