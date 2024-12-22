extends Node2D

func get_floor(floor_num: int) -> Node:
	return get_node("Floor_" + str(floor_num))
