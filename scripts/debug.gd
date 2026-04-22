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
	var npcs_timer = get_node("/root/Main/Timers/NPCsTimer")
	$Dynamic.text = ""
	$Dynamic.text += "enter interval: %ss\n" % npcs_timer.wait_time
	$Dynamic.text += "time scale: x%s\n" % Engine.get_time_scale()
	$Dynamic.text += "Q -> faster\n"
	$Dynamic.text += "A -> slower"

func _get_level_desc() -> String:
	# var total_shift = (start_enter_interval - Settings.npc_enter_min_sec)
	# var span_count = ceil(total_shift / Settings.npc_enter_shift_sec)
	# var time_sec = span_count * span_duration
	# var time_min = Funcs.snap_two(time_sec / 60)
	# return "span time: %ss\nmin enter: %sm" % [span_duration, time_min]
	var lines = []
	for type in ["Bomb", "Businessman"]:
		var freq = NPCs.npc_frequencies[Npc.Type[type]]
		lines.append("%s: 1:%s" % [type, freq])
	return "\n".join(lines)