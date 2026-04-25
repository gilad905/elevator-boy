class_name LevelManager extends Node

static var _npcs_timer_timeout
static var span_duration: float
static var start_enter_interval: float
static var _money_reached

static func init_level(angries_reached, money_reached, npcs_timer_timeout) -> void:
	State.money_count = 0
	Nodes.HUD.init_from_state()
	_npcs_timer_timeout = npcs_timer_timeout
	_money_reached = money_reached
	Nodes.Elevator.angries_reached.connect(angries_reached.emit)
	Nodes.Elevator.money_reached.connect(money_reached.emit)
	for _floor in Nodes.Floors.get_children():
		_floor.angries_reached.connect(angries_reached.emit)
		_floor.money_reached.connect(money_reached.emit)
	Nodes.Closet.load_from_state()
	span_duration = get_speed_span_duration(State.current_level)
	start_enter_interval = get_start_enter_interval(State.current_level)
	NPCs.update_weights_by_level(State.current_level)
	# print("angry_count: %d" % State.angry_count)
	Nodes.Timers.get_node("SpeedSpanTimer").wait_time = span_duration
	Nodes.Timers.get_node("NPCsTimer").wait_time = start_enter_interval

static func start_level() -> void:
	_npcs_timer_timeout.emit()
	Nodes.Timers.get_node("NPCsTimer").start()
	Nodes.Timers.get_node("SpeedSpanTimer").start()
	Nodes.AudioManager.play_music("Bossa-radio-1")

static func end_level() -> void:
	Nodes.AudioManager.stop_music()
	Nodes.Timers.get_node("NPCsTimer").stop()
	Nodes.Timers.get_node("SpeedSpanTimer").stop()

static func get_speed_span_duration(_level_num: int) -> float:
	var shift = Settings.speed_span_level_shift_sec * (_level_num - 1)
	var duration = Settings.speed_span_max_sec - shift
	duration = max(duration, Settings.speed_span_min_sec)
	return duration

static func get_start_enter_interval(_level_num: int) -> float:
	var interval = Settings.npc_enter_max_sec
	interval -= (_level_num - 1) * Settings.npc_enter_shift_sec
	interval = max(interval, Settings.npc_enter_min_sec)
	return interval