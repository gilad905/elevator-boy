extends Node

var root: Window
var npcs: Node
var hud: Node2D
var floors: Node2D
var elevator: Node2D

func intialize() -> void:
	root = get_node("/root")
	npcs = root.get_node("Main/NPCs")
	hud = root.get_node("Main/HUD")
	floors = root.get_node("Main/Floors")
	elevator = root.get_node("Main/Elevator")