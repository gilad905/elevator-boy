extends Node

const NOT_MOVING: int = -1
var max_speed: int = Global.elevator_max_speed
var offset_to_floor: int
var halt_distance: int
var current_y: float:
	get:
		return get_parent().position.y
	set(value):
		get_parent().position.y = value

var target_floor_num: int = NOT_MOVING
var target_y: float = NOT_MOVING
var acceleration: int = 0
var speed: float = 0.0

signal reached_floor

func _ready() -> void:
	var floor_1 = Nodes.floors.get_floor(1)
	var floor_2 = Nodes.floors.get_floor(2)
	var one_floor_height = (floor_1.position.y - floor_2.position.y)
	halt_distance = one_floor_height * .76
	var current_floor_num = Global.floor_count
	var current_floor = Nodes.floors.get_floor(current_floor_num)
	offset_to_floor = current_y - current_floor.position.y

func _physics_process(delta: float) -> void:
	if acceleration != 0:
		var distance = abs(target_y - current_y)
		if distance <= 1:
			acceleration = 0
			speed = 0
			current_y = target_y
			target_floor_num = NOT_MOVING
			target_y = NOT_MOVING
			reached_floor.emit()
			return
		if distance <= halt_distance:
			if abs(speed) == max_speed:
				acceleration *= -1
				print("acceleration: ", acceleration)
		var already_at_max = abs(speed) == max_speed
		speed += acceleration
		speed = clamp(speed, -max_speed, max_speed)
		print("%s %s" % [distance, speed])
		if abs(speed) == max_speed and not already_at_max:
			print("max speed")
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
