extends Person

func _ready() -> void:
	type = Npc.Type.Businessman
	patience_sec = Global.npc_meta[type].patience_sec
	start_patience_tween()