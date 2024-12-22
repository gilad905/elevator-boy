extends Node2D

func debug_fill_elevator_with_persons():
	for i in 4:
		var person = $Persons.create_person(i + 1)
		$Elevator.add_person(person)