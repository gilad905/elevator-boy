extends Person

func _ready() -> void:
	type = Npc.Type.Businessman
	patience_sec = Global.npc_meta[type].patience_sec
	super()

func remove_with_result(is_happy: bool) -> Signal:
	if is_happy and Nodes.Closet.has_room():
		Nodes.Closet.add_random_item()
	return super(is_happy)