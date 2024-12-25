extends Node2D

func debug_fill_elevator_with_persons():
	for i in 4:
		var person = $Persons.create_person(i + 1)
		$Elevator.add_person(person)

func debug_test_reparent():
	var person_scene = preload("res://scenes/person.tscn")
	var person = person_scene.instantiate()
	$Floors/Floor_1/Persons.add_child(person)
	pass
	person.reparent($Floors/Floor_2/Persons, false)
	print(person.position)
