extends VBoxContainer

func load_labels() -> void:
	var pref = "DEBUG " if Settings.debugging else ""
	$Version.text = pref + Settings.version
	var level_desc = get_level_desc()
	$Level.text = level_desc
	update_dynamic_labels()

func get_level_desc() -> String:
	# var total_shift = (start_enter_interval - Settings.npc_enter_min_sec)
	# var span_count = ceil(total_shift / Settings.npc_enter_shift_sec)
	# var time_sec = span_count * span_duration
	# var time_min = Funcs.snap_two(time_sec / 60)
	# return "span time: %ss\nmin enter: %sm" % [span_duration, time_min]
	var desc = ""
	for type in ["Bomb", "Businessman"]:
		desc += "%s: 1:%s\n" % [type, NPCs.npc_frequencies[Npc.Type[type]]]
	return desc

func update_dynamic_labels() -> void:
	var npcs_timer = get_node("/root/Main/Timers/NPCsTimer")
	var args = [npcs_timer.wait_time, Engine.get_time_scale()]
	$Dynamic.text = "enter interval: %ss\ntime scale: x%s" % args
