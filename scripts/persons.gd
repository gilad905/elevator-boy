extends Node

var person_scene
var floors

func _ready() -> void:
	person_scene = preload("res://scenes/person.tscn")
	floors = get_node("../Floors")

func add_random_person(floor_num: int = 0, dest: int = 0) -> void:
	var _floor
	if floor_num:
		_floor = floors.get_floor(floor_num)
	else:
		_floor = get_random_free_floor()
		if not _floor:
			return
	if not dest:
		dest = get_random_dest(floor_num)
	add_person_at_floor(_floor, dest)

func add_person_at_floor(_floor: Node2D, dest: int) -> void:
	assert(_floor.has_room(), "Floor " + _floor.name + " is full")
	var person = create_person(dest)
	_floor.add_person(person)

func create_person(dest: int) -> Node:
	var person = person_scene.instantiate()
	person.set_dest(dest)
	return person

func get_random_free_floor() -> Node2D:
	var all_floors = floors.get_children()
	var free_floors = all_floors.filter(func(x): return x.has_room())
	return free_floors.pick_random()

func get_random_dest(floor_num: int) -> int:
	var random_floor = randi_range(1, Global.floor_count - 1)
	if random_floor >= floor_num:
		random_floor += 1
	return random_floor
