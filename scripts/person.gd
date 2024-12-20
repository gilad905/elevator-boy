class_name Person extends Area2D

var dest: int = -1

func _init(_dest: int) -> void:
    set_dest(_dest)

func set_dest(_dest: int) -> void:
    dest = _dest
    print(get_children())
    var label = get_node("./Label")
    label.text = str(_dest)