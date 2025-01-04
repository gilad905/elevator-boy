extends Node2D

func get_floor(floor_num: int) -> Node:
	return get_node("Floor_" + str(floor_num))

func set_floor_pressed(floor_num: int) -> void:
	for _floor in get_children():
		_floor.set_pressed(false)
	get_floor(floor_num).set_pressed(true)

func floor_exists(floor_num: int) -> bool:
	return floor_num >= 1 and floor_num <= Global.floor_count
