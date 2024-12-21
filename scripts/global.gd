extends Node

var floor_count: int
var person_radius: int = 10
var person_spacing: int = 5

func _ready() -> void:
    var root = get_tree().root
    floor_count = root.get_node("Main/Floors").get_child_count()