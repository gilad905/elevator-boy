extends Node

var root: Window
var persons: Node
var hud: Node2D
var floors: Node2D
var elevator: Node2D

func _ready() -> void:
	root = get_node("/root")
	persons = root.get_node("Main/Persons")
	hud = root.get_node("Main/HUD")
	floors = root.get_node("Main/Floors")
	elevator = root.get_node("Main/Elevator")