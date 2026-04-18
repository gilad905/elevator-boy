class_name Nodes extends Node

static var HUD: Node2D
static var Floors: Node2D
static var Elevator: Node2D
static var Closet: Control
static var Foreground: ColorRect

func _enter_tree() -> void:
	var path = "/root/Main/%s"
	for key in ["HUD", "Floors", "Elevator", "Closet", "Foreground"]:
		self[key] = get_node(path % key)
