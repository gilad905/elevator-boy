extends Person

func _init() -> void:
	type = Npc.Type.Businessman
	super ()

func show_result(is_happy: bool) -> void:
	if is_happy and Nodes.Closet.has_room():
		Nodes.Closet.add_random_item()
	super (is_happy)
