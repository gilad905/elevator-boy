extends Node

var elevator: Room = get_parent()
var current_y: float:
	get: return elevator.position.y
var target_y: float
var acceleration: int = 0
var speed: float = 0.0

signal reached_floor

func _process(delta: float) -> void:
	if acceleration != 0:
		if target_y == current_y:
			acceleration = 0
			reached_floor.emit()
		else:

func move_to_floor(floor_num: int) -> void:
	var _floor = Nodes.floors.get_floor(floor_num)
	target_y = _floor.position.y
	acceleration = 1 if target_y > current_y else -1
	await reached_floor