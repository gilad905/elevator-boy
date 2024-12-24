extends Node2D

@export var on_forground: Color
@export var on_background: Color

func get_floor(floor_num: int) -> Node:
	return get_node("Floor_" + str(floor_num))

func set_pressed(floor_num: int) -> void:
	for _floor in get_children():
		_floor.set_pressed(false)
	get_floor(floor_num).set_pressed(true)