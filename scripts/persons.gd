extends Node

var person_scene
var floors

func _ready() -> void:
	person_scene = preload("res://scenes/person.tscn")
	floors = get_node("../Floors")

func add_person(floor_num: int = 0, dest: int = 0) -> void:
	floor_num = floor_num if floor_num else get_random_floor_num()
	dest = dest if dest else get_random_dest(floor_num)
	var _floor = floors.get_node("Floor_" + str(floor_num))
	var person = create_person(dest)
	_floor.add_person(person)

func create_person(dest: int) -> Node:
	# var test = Person.new(1)
	var person = person_scene.instantiate()
	person.set_dest(dest)
	return person

func get_random_floor_num() -> int:
	return randi_range(1, Global.floor_count)

func get_random_dest(floor_num: int) -> int:
	var random_floor = randi_range(0, Global.floor_count - 1)
	if random_floor >= floor_num:
		random_floor += 1
	return random_floor