extends Node2D

@export var pressed_forground: Color
@export var pressed_background: Color

func get_floor(floor_num: int) -> Node:
	return get_node("Floor_" + str(floor_num))

func set_floor_pressed(floor_num: int) -> void:
	for _floor in get_children():
		_floor.set_pressed(false)
	get_floor(floor_num).set_pressed(true)
