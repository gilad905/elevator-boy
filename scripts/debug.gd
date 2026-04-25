extends VBoxContainer

func _ready() -> void:
	if not Env.is_dev:
		hide()

func load_labels() -> void:
	if not Env.is_dev:
		return
	var pref = "DEBUG " if Env.is_dev else ""
	$Version.text = pref + Env.version
	var level_desc = _get_level_desc()
	$Level.text = level_desc
	update_dynamic_labels()

func update_dynamic_labels() -> void:
	if not Env.is_dev:
		return
	$Dynamic.text = ""
	# var npcs_timer = get_node("/root/Main/Timers/NPCsTimer")
	# $Dynamic.text += "enter interval: %ss\n" % npcs_timer.wait_time
	$Dynamic.text += "time scale: x%s\n" % Engine.get_time_scale()
	$Dynamic.text += "Q -> faster\n"
	$Dynamic.text += "A -> slower"

func _get_level_desc() -> String:
	var lines = []
	lines.append("patience multiplier: %s" % State.patience_multiplier)
	for type in Settings.npc_meta.keys():
		var type_name = Npc.Type.keys()[type]
		var weight = NPCs.npc_weights[type]
		lines.append("%s weight: %s" % [type_name, weight])
	return "\n".join(lines)