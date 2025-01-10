class_name Nodes extends Node

static var HUD: Node2D
static var Floors: Node2D
static var Elevator: Node2D
static var Closet: Control

func _enter_tree() -> void:
	var path = "/root/Main/%s"
	for key in ["HUD", "Floors", "Elevator", "Closet"]:
		self[key] = get_node(path % key)