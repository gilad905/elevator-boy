extends Node

var root: Node
var hud: Node
var persons: Node
var floors: Node
var elevator: Node

func _ready() -> void:
	root = get_node("/root")
	hud = root.get_node("/Main/HUD")
	persons = root.get_node("/Main/Persons")
	floors = root.get_node("/Main/Floors")
	elevator = root.get_node("/Main/Elevator")