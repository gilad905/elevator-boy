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
	var args = [npcs_timer.wait_time, Engine.get_time_scale()]
	$Dynamic.text = "enter interval: %ss\ntime scale: x%s" % args

func _get_level_desc() -> String:
	# var total_shift = (start_enter_interval - Settings.npc_enter_min_sec)
	# var span_count = ceil(total_shift / Settings.npc_enter_shift_sec)
	# var time_sec = span_count * span_duration
	# var time_min = Funcs.snap_two(time_sec / 60)
	# return "span time: %ss\nmin enter: %sm" % [span_duration, time_min]
	var desc = ""
	for type in ["Bomb", "Businessman"]:
		desc += "%s: 1:%s\n" % [type, NPCs.npc_frequencies[Npc.Type[type]]]
	return desc