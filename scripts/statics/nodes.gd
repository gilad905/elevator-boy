class_name Nodes extends Node

static var HUD: Node2D
static var Floors: Node2D
static var Elevator: Node2D

func _enter_tree() -> void:
	HUD = get_node("/root/Main/HUD")
	Floors = get_node("/root/Main/Floors")
	Elevator = get_node("/root/Main/Elevator")