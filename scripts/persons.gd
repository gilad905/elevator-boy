extends Node

@export var patience_sec: int
@export var move_speed: float

var person_scene
var floors

func _ready() -> void:
	person_scene = preload("res://scenes/person.tscn")
	floors = get_node("../Floors")

func add_random_person(floor_num: int = 0, dest: int = 0) -> void:
	if not floor_num:
		floor_num = get_random_free_floor_num()
		if not floor_num:
			return
	if not dest:
		dest = get_random_dest(floor_num)
	add_person_at_floor(floor_num, dest)

func add_person_at_floor(floor_num: int, dest: int) -> void:
	var _floor = floors.get_floor(floor_num)
	assert(_floor.has_room(), "Floor " + _floor.name + " is full")
	var person = create_person(dest)
	_floor.add_person(person)

func create_person(dest: int) -> Node:
	var person = person_scene.instantiate()
	person.set_dest(dest)
	return person

func get_random_free_floor_num() -> int:
	var all_nums = range(1, Global.floor_count + 1)
	var free_nums = all_nums.filter(floor_has_room)
	var free_num = free_nums.pick_random()
	return free_num if free_num else 0

func floor_has_room(floor_num: int) -> bool:
	return floors.get_floor(floor_num).has_room()

func get_random_dest(source_floor_num: int) -> int:
	var random_floor = randi_range(1, Global.floor_count - 1)
	if random_floor >= source_floor_num:
		random_floor += 1
	return random_floor
