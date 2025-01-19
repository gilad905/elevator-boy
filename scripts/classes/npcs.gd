class_name NPCs extends Node

const scene_path = "res://scenes/npcs/%s.tscn"
static var npc_frequencies
static var scenes = {}

static func _static_init() -> void:
	scenes = Funcs.get_scenes_by_type(scene_path, Npc.Type)

static func update_frequencies() -> void:
	npc_frequencies = _get_npc_frequencies()
	# print(Global.current_level, " ", npc_frequencies)

static func add_random_npc() -> Node2D:
	var floor_num = get_random_free_floor_num()
	if not floor_num:
		return
	var _floor = Nodes.Floors.get_floor(floor_num)
	var type = get_random_type()
	var npc = scenes[type].instantiate()
	if npc is Person:
		var dest = get_random_dest(floor_num)
		npc.set_dest(dest)
	_floor.add_npc(npc)
	return npc

static func get_random_type() -> Npc.Type:
	for type in npc_frequencies:
		var frequency = npc_frequencies[type]
		if frequency != 0 and (randi() % frequency == 0):
			return type
	return Npc.Type.Person

static func get_random_free_floor_num() -> int:
	var all_nums = range(1, Global.floor_count + 1)
	var free_nums = all_nums.filter(floor_has_room)
	var free_num = free_nums.pick_random()
	return free_num if free_num else 0

static func floor_has_room(floor_num: int) -> bool:
	return Nodes.Floors.get_floor(floor_num).has_room()

static func get_random_dest(source_floor_num: int) -> int:
	var random_floor = randi_range(1, Global.floor_count - 1)
	if random_floor >= source_floor_num:
		random_floor += 1
	return random_floor

static func add_result_tweener(tween: Tween, result: Node2D):
	var scale = result.scale.x
	var duration = Global.npc_result_sec
	for type in ["x", "y"]:
		tween.tween_property(result, "scale:" + type, scale * 2, duration)
	await tween.finished
	for type in ["x", "y"]:
		result.scale[type] = scale

static func _get_npc_frequencies() -> Dictionary:
	var frequencies = {}
	for type in Npc.Type.values():
		if type == Npc.Type.Unset:
			continue
		frequencies[type] = _get_npc_frequency(type)
	return frequencies

static func _get_npc_frequency(type: Npc.Type) -> int:
	if Global.debugging and type == Npc.Type.Bomb:
		return 2
	var start_freq = Global.npc_meta[type].start_frequency
	if start_freq <= 0:
		return start_freq
	if Global.current_level == 1:
		return 0
	var level = min(Global.current_level, 10)
	var freq = start_freq + (level - 2) * -2
	freq = max(freq, 1)
	return freq