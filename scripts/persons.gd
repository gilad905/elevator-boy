extends Node

var person_scene = preload("res://scenes/person.tscn")
var bomb_scene = preload("res://scenes/bomb.tscn")

func add_random_npc() -> Node2D:
	var floor_num = get_random_free_floor_num()
	if not floor_num:
		return
	var is_bomb = false
	if Global.bomb_one_in > 0:
		is_bomb = randi() % Global.bomb_one_in == 0
	var npc
	if is_bomb:
		var _floor = Nodes.floors.get_floor(floor_num)
		npc = bomb_scene.instantiate()
		_floor.add_person(npc)
	else:
		var dest = get_random_dest(floor_num)
		add_person_at_floor(floor_num, dest)
	return npc

func add_person_at_floor(floor_num: int, dest: int) -> Node2D:
	var _floor = Nodes.floors.get_floor(floor_num)
	var person = create_person(dest)
	_floor.add_person(person)
	return person

func create_person(dest: int) -> Node2D:
	var person = person_scene.instantiate()
	person.init(dest)
	return person

func get_random_free_floor_num() -> int:
	var all_nums = range(1, Global.floor_count + 1)
	var free_nums = all_nums.filter(floor_has_room)
	var free_num = free_nums.pick_random()
	return free_num if free_num else 0

func floor_has_room(floor_num: int) -> bool:
	return Nodes.floors.get_floor(floor_num).has_room()

func get_random_dest(source_floor_num: int) -> int:
	var random_floor = randi_range(1, Global.floor_count - 1)
	if random_floor >= source_floor_num:
		random_floor += 1
	return random_floor

func add_result_tweener(tween: Tween, result: Node2D):
	var scale = result.scale.x
	var duration = Global.person_result_sec
	for type in ["x", "y"]:
		tween.tween_property(result, "scale:" + type, scale * 2, duration)
	await tween.finished
	for type in ["x", "y"]:
		result.scale[type] = scale
