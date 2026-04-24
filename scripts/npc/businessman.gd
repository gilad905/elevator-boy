extends Person

func _init() -> void:
	type = Npc.Type.Businessman
	super ()

func show_result(is_happy: bool) -> void:
	if is_happy:
		Nodes.Closet.add_random_item()
	super (is_happy)
