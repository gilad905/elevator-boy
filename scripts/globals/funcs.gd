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

static func get_random_by_frequency(frequency: int) -> bool:
	return frequency != 0 and (randi() % frequency == 0)

static func fly_node_to(_node, _position, _speed) -> Tween:
	var duration = _node.position.distance_to(_position) / _speed
	var movement_tween = _node.create_tween()
	movement_tween.tween_property(_node , "position", _position, duration)
	return movement_tween