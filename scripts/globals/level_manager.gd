class_name LevelManager extends Node

static var _npcs_timer_timeout
static var _money_reached

static func init_level(angries_reached, money_reached, npcs_timer_timeout) -> void:
	State.money_count = 0
	_npcs_timer_timeout = npcs_timer_timeout
	_money_reached = money_reached
	Nodes.Elevator.angries_reached.connect(angries_reached.emit)
	Nodes.Elevator.money_reached.connect(money_reached.emit)
	for _floor in Nodes.Floors.get_children():
		_floor.angries_reached.connect(angries_reached.emit)
		_floor.money_reached.connect(money_reached.emit)
	Nodes.HUD.init_from_state()
	Nodes.Closet.load_from_state()
	NPCs.init_level(State.current_level)

static func start_level() -> void:
	_npcs_timer_timeout.emit()
	Nodes.Timers.get_node("NPCsTimer").start()
	Nodes.AudioManager.play_music("Bossa-radio-1")

static func end_level() -> void:
	Nodes.AudioManager.stop_music()
	Nodes.Timers.get_node("NPCsTimer").stop()