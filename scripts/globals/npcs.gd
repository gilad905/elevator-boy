class_name NPCs extends Node

const scene_path = "res://scenes/npcs/%s.tscn"
static var npc_frequencies
static var scenes = {}

static func _static_init() -> void:
	for type_name in Npc.Type:
		if type_name != "Unset":
			var type_val = Npc.Type[type_name]
			var type_scene = Funcs.get_scene_by_type(scene_path, type_name)
			scenes[type_val] = type_scene

static func update_frequencies() -> void:
	npc_frequencies = _get_npc_frequencies()
	# print(State.current_level, " ", npc_frequencies)

static func add_random_npc() -> Node2D:
	var floor_num = get_random_free_floor_num()
	# if Env.is_dev:
	# 	print("DEV - adding at floor 5")
	# 	floor_num = 5

	if not floor_num:
		return
	var _floor = Nodes.Floors.get_floor(floor_num)
	var type = get_random_type()
	# if Env.is_dev:
	# 	# temp_npc_count += 1
	# 	# if temp_npc_count % 3 == 0:
	# 	print("DEV - adding businessman")
	# 	type = Npc.Type.Businessman
	var npc = scenes[type].instantiate()
	Nodes.AudioManager.play_sound("Footsteps")
	await show_npc_guide(type)
	if npc is Person:
		var dest = get_random_dest(floor_num)
		npc.set_dest(dest)
	_floor.add_npc(npc)
	return npc

static func show_npc_guide(type: Npc.Type) -> void:
	var npc_meta = Settings.npc_meta[type]
	if "guide" in npc_meta and \
	not State.viewed_guides.has(npc_meta.guide):
		State.viewed_guides.append(npc_meta.guide)
		var modal = Nodes.Main.get_node("Foreground/Modal")
		await modal.show_modal(npc_meta.guide)

static func get_random_type() -> Npc.Type:
	for type in npc_frequencies:
		var frequency = npc_frequencies[type]
		if Funcs.get_random_by_frequency(frequency):
			return type
	return Npc.Type.Person

static func get_random_free_floor_num() -> int:
	var all_nums = range(1, Settings.floor_count + 1)
	var free_nums = all_nums.filter(floor_has_room)
	var free_num = free_nums.pick_random()
	return free_num if free_num else 0

static func floor_has_room(floor_num: int) -> bool:
	return Nodes.Floors.get_floor(floor_num).has_room()

static func get_random_dest(source_floor_num: int) -> int:
	var random_floor = randi_range(1, Settings.floor_count - 1)
	if random_floor >= source_floor_num:
		random_floor += 1
	return random_floor

static func tween_floater(floater: Node2D) -> void:
	var scale = floater.scale.x
	var duration = Settings.npc_result_duration
	var tween = floater.create_tween()
	tween.set_parallel()
	for type in ["x", "y"]:
		tween.tween_property(floater, "scale:" + type, scale * 2, duration)
	await tween.finished
	for type in ["x", "y"]:
		floater.scale[type] = scale

static func _get_npc_frequencies() -> Dictionary:
	var frequencies = {}
	for type in Npc.Type.values():
		if type == Npc.Type.Unset:
			continue
		frequencies[type] = _get_npc_frequency(type)
	return frequencies

static func _get_npc_frequency(type: Npc.Type) -> int:
	# if Env.is_dev and type == Npc.Type.Bomb:
	# 	print("setting bomb frequency 2")
	# 	return 2
	var start_freq = Settings.npc_meta[type].start_frequency
	if start_freq <= 0:
		return start_freq
	if State.current_level == 1:
		return 0
	var level = min(State.current_level, 10)
	var freq = start_freq + (level - 2) * -2
	freq = max(freq, 1)
	return freq