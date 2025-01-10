extends Person

func _ready() -> void:
	npc_type = Npc.Type.Businessman
	patience_sec = Global.npc_meta[npc_type].patience_sec
	start_patience_tween()