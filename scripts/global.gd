extends Node

var floor_count: int

func _ready() -> void:
    var root = get_tree().root
    floor_count = root.get_node("Main/Floors").get_child_count()