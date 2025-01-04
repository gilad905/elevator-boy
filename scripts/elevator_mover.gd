extends Node

const NOT_MOVING: int = -1
var target_floor_num: int = NOT_MOVING
var target_y: float = NOT_MOVING
var acceleration: int = 0
var speed: float = 0.0
var max_speed: int = Global.elevator_max_speed
var offset_to_floor: int
var current_y: float:
	get:
		return get_parent().position.y
	set(value):
		get_parent().position.y = value

signal reached_floor

func _ready() -> void:
	var current_floor_num = Global.floor_count
	var current_floor = Nodes.floors.get_floor(current_floor_num)
	offset_to_floor = current_y - current_floor.position.y

func _process(delta: float) -> void:
	if acceleration != 0:
		if abs(target_y - current_y) <= 10:
			current_y = target_y
			target_floor_num = NOT_MOVING
			target_y = NOT_MOVING
			acceleration = 0
			speed = 0
			reached_floor.emit()
		else:
			speed += acceleration
			speed = clamp(speed, -max_speed, max_speed)
			var position_delta = speed * delta
			current_y += position_delta

func move_to(floor_num: int) -> void:
	if floor_num != target_floor_num:
		target_floor_num = floor_num
		var _floor = Nodes.floors.get_floor(floor_num)
		target_y = _floor.position.y + offset_to_floor
		acceleration = 1 if target_y > current_y else -1
		acceleration *= Global.elevator_acceleration
		print("current_y %s, target_y %s, acceleration %s" % [current_y, target_y, acceleration])
	await reached_floor
