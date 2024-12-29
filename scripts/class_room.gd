extends Node2D

var person_limit: int = 0
var hud

func add_person(person) -> void:
	hud = get_node("/root/Main/HUD")
	person.patience_ended.connect(_on_person_patience_ended)
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

func remove_person(person: Node2D, is_happy: bool):
	person.patience_ended.disconnect(_on_person_patience_ended)
	var removed = person.remove(is_happy)
	removed.connect(_remove_person_node.bind(person))
	return removed

func _on_person_patience_ended(_person: Node2D) -> void:
	pass

func _remove_person_node(person: Node2D) -> void:
	$Persons.remove_child(person)
	person.queue_free()
