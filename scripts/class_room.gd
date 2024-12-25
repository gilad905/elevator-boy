extends Area2D

var person_limit: int = 0

func add_person(person) -> void:
	person.timeout_reached.connect(_on_person_timeout_reached)
	update_person_position(person)

func get_person_position(_i: int) -> Vector2:
	return Vector2.ZERO

func update_person_position(person: Node2D):
	var i = person.get_index()
	var _position = get_person_position(i)
	person.move_to(_position)

func update_person_positions() -> void:
	for person in $Persons.get_children():
		update_person_position(person)

func has_room() -> bool:
	return $Persons.get_child_count() < person_limit

func _on_person_timeout_reached(_person: Node2D) -> void:
	pass
