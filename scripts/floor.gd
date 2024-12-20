class_name Floor extends Area2D

func add_person(person) -> void:
	add_child(person)
	var i = person.get_index()
	var _position = get_person_position(i)
	person.position = _position

func get_person_position(i: int) -> Vector2:
	return Vector2(i * 50, 0)
