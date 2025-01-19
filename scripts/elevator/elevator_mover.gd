extends Node

const tween_types = preload("res://resources/elevator_mover_tweens.gd").obj
var half_floor_height: int
var half_floor_sec: float = Settings.half_floor_sec
var current_floor: float
var current_direction: int
var current_tween_type: Dictionary
var current_tween: Tween
var target_floor: int

signal done

func _ready() -> void:
	half_floor_height = Nodes.Floors.floor_height / 2
	current_floor = Settings.floor_count
	current_direction = 0
	current_tween_type = tween_types.stop # just to have "to" on 0

func move_to(floor_num: int) -> void:
	target_floor = floor_num
	if not current_tween or not current_tween.is_running():
		process_half_floor()
	await done

func process_half_floor():
	var distance = current_floor - target_floor
	var from = current_direction

	if distance == 0 and from == 0:
		done.emit()
	else:
		var to = get_to(from, distance)
		var tween_name = get_tween_name(from, to)
		var tween_direction = to if to != 0 else from
		if tween_direction == 0:
			tween_direction = distance / abs(distance)
		# var args = [current_floor, from, to, tween_direction, tween_name]
		# print("floor %s from %s to %s direction %s: %s" % args)
		current_tween_type = tween_types[tween_name]
		current_tween = create_tween_of_type(current_tween_type, tween_direction)
		current_tween.finished.connect(process_half_floor)
		current_direction = to
		# direction is y-based, floors are the opposite
		current_floor += tween_direction * -0.5

func get_to(from, distance) -> int:
	var to = 0
	var abs_distance = abs(distance)
	if abs_distance > .5:
		var target_direction = distance / abs_distance
		var need_to_reverse = (from * target_direction) == -1
		if not need_to_reverse:
			to = target_direction
	return to

func get_tween_name(from, to) -> String:
	var abs_from = abs(from)
	var abs_to = abs(to)
	for _name in tween_types:
		var type = tween_types[_name]
		if type.abs_from == abs_from and type.abs_to == abs_to:
			return _name
	return ""

func create_tween_of_type(type, direction) -> Tween:
	var tween = create_tween()
	tween.set_trans(type.trans)
	tween.set_ease(type.ease)
	var distance = half_floor_height * direction
	tween.tween_property(get_parent(), "position:y", distance, half_floor_sec).as_relative()
	return tween
