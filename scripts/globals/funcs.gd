class_name Funcs

static func _print(msg: String) -> void:
	var time = Time.get_time_string_from_system()
	print(time + " " + msg)

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

static func fly_node_to(_node, _position, _speed) -> Tween:
	var duration = _node.position.distance_to(_position) / _speed
	var movement_tween = _node.create_tween()
	movement_tween.tween_property(_node, "position", _position, duration)
	return movement_tween

# weight_meta: { [type]: <weight>, ... }
static func roll_by_weights(weight_meta: Dictionary) -> int:
	var weighted_keys = []
	for key in weight_meta.keys():
		var weight: int = weight_meta[key]
		if weight <= 0:
			continue
		var key_weights = range(weight).map(func(_n): return key)
		weighted_keys.append_array(key_weights)
	var key = weighted_keys.pick_random()
	# print("weights: ", weight_meta)
	# print("weighted_keys: ", weighted_keys)
	# print("picked key: ", key)
	return key