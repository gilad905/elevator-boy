class_name Nodes extends Node

static var Main
static var HUD
static var Floors
static var Elevator
static var Closet
static var Timers
static var AudioManager

func _enter_tree() -> void:
	var path = "/root/Main/%s"
	self.Main = get_node("/root/Main")
	for key in ["HUD", "Floors", "Elevator", "Closet", "Timers", "AudioManager"]:
		self[key] = get_node(path % key)
