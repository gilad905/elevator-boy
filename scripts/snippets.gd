extends Node2D

func debug_fill_elevator_with_npcs():
	for i in 4:
		var person = $NPCs.create_person(i + 1)
		$Elevator.add_person(person)

func debug_test_reparent():
	var person_scene = preload("res://scenes/person.tscn")
	var person = person_scene.instantiate()
	$Floors/Floor_1/NPCs.add_child(person)
	pass
	person.reparent($Floors/Floor_2/NPCs, false)
	print(person.position)
