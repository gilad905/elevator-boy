extends Node2D

func get_floor(floor_num: int) -> Node:
	return get_node("Floor_" + str(floor_num))


func _on_elevator_enter_timer_timeout() -> void:
	pass # Replace with function body.
