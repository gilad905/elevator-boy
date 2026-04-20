extends Node2D

var _floor_height: int = -1
var floor_height:
	get:
		if _floor_height == -1:
			_floor_height = get_floor(1).position.y - get_floor(2).position.y
		return _floor_height

func get_floor(floor_num: int) -> Node:
	return get_node("Floor_" + str(floor_num))

func set_floor_pressed(floor_num: int) -> void:
	for _floor in get_children():
		_floor.set_pressed(false)
	get_floor(floor_num).set_pressed(true)

func floor_exists(floor_num: int) -> bool:
	return floor_num >= 1 and floor_num <= Settings.floor_count

func enter_elevator_next() -> void:
	var floor_num = Nodes.Elevator.current_floor_num
	var _floor = get_floor(floor_num)
	if _floor:
		_floor.enter_elevator_next()
