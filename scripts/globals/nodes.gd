class_name Nodes extends Node

static var HUD
static var Floors
static var Elevator
static var Closet

func _enter_tree() -> void:
	var path = "/root/Main/%s"
	for key in ["HUD", "Floors", "Elevator", "Closet"]:
		self[key] = get_node(path % key)
