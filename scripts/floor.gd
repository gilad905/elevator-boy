class_name Floor extends Area2D

var persons: Node2D
# var inner_right: int

@export var person_spacing: int = 5

func _ready() -> void:
	# inner_right = get_node("CollisionShape2D").shape.size.x
	persons = get_node("Persons")
	get_node("FloorNum").text = str(get_index() + 1)

func add_person(person) -> void:
	persons.add_child(person)
	var i = person.get_index()
	var _position = get_person_position(i)
	person.position = _position

func get_person_position(i: int) -> Vector2:
	var radius = Global.person_radius
	var x = person_spacing + (person_spacing + radius * 2) * i
	return Vector2(x, 25)
