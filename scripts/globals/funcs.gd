class_name Funcs

static func _print(msg: String) -> void:
	var time = Time.get_time_string_from_system()
	print(time + " " + msg)

static func snap_two(val: float) -> float:
	return snapped(val, 0.01)

static func get_scenes_by_type(base_path, types) -> Dictionary:
	var scenes = {}
	for type_name in types:
		var type_val = types[type_name]
		var _scene = get_scene_by_type(base_path, type_name)
		scenes[type_val] = _scene
	return scenes

static func get_scene_by_type(base_path, type_name) -> PackedScene:
	var path = base_path % type_name.to_lower()
	return load(path)