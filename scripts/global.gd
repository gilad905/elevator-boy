extends Node

var floor_count: int
var person_radius: int = 10
var person_spacing: int = 5

func _ready() -> void:
    floor_count = get_node("/root/Main/Floors").get_child_count()