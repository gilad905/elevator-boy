extends Node2D

var person_limit: int = 0

func add_person(person) -> void:
    assert(has_room(), name + " is full")
    $Persons.add_child(person)
    update_person_position(person)

func update_person_position(person: Node2D):
    var spacing = Global.person_spacing
    var radius = Global.person_radius
    var i = person.get_index()
    var x = spacing + (spacing + radius * 2) * i
    var _position = Vector2(x, 25)
    person.position = _position

func update_person_positions() -> void:
    for person in $Persons.get_children():
        update_person_position(person)

func has_room() -> bool:
    return $Persons.get_child_count() < person_limit