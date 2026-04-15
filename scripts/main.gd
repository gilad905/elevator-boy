extends Node

var span_duration: float
var start_enter_interval: float
var current_span: int = 1

func _ready() -> void:
	init_level()
	$Debug.load_labels()
	$Modal.show_modal("LEVEL %d - GET READY" % State.current_level)
	await get_tree().create_timer(1, false).timeout
	start_level()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("time_scale_increase"):
		set_time_scale(true)
	elif event.is_action_pressed("time_scale_decrease"):
		set_time_scale(false)

func init_level() -> void:
	span_duration = get_speed_span_duration()
	start_enter_interval = get_start_enter_interval()
	NPCs.update_frequencies()
	$Timers/ElevatorEnterTimer.wait_time = Settings.elevator_check_interval_sec
	$Timers/SpeedSpanTimer.wait_time = span_duration
	$Timers/NPCsTimer.wait_time = start_enter_interval

func start_level() -> void:
	_on_npcs_timer_timeout()
	$Timers/NPCsTimer.start()
	$Timers/SpeedSpanTimer.start()

func set_time_scale(to_increase: bool):
	var time_scale = Engine.get_time_scale()
	var shift = 2.0 if to_increase else 0.5
	time_scale = clamp(time_scale * shift, 0.125, 32.0)
	Engine.set_time_scale(time_scale)
	$Debug.update_dynamic_labels()

func get_speed_span_duration() -> float:
	var shift = Settings.speed_span_level_shift_sec * (State.current_level - 1)
	var duration = Settings.speed_span_max_sec - shift
	duration = max(duration, Settings.speed_span_min_sec)
	return duration

func get_start_enter_interval() -> float:
	var interval = Settings.npc_enter_max_sec
	interval -= (State.current_level - 1) * Settings.npc_enter_shift_sec
	interval = max(interval, Settings.npc_enter_min_sec)
	return interval

func _on_npcs_timer_timeout() -> void:
	NPCs.add_random_npc()

func _on_door_state_changed(state: int) -> void:
	if state == $Elevator/Door.DoorState.open:
		$Elevator.remove_persons_in_dest()
		_on_elevator_enter_timer_timeout()
		$Timers/ElevatorEnterTimer.start()
	elif state == $Elevator/Door.DoorState.closing:
		$Timers/ElevatorEnterTimer.stop()

func _on_elevator_enter_timer_timeout():
	var floor_num = $Elevator.current_floor_num
	var _floor = $Floors.get_floor(floor_num)
	_floor.enter_elevator_next()

func _on_speed_span_timer_timeout() -> void:
	current_span += 1
	var wait_time = $Timers/NPCsTimer.wait_time
	var new_time = wait_time - Settings.npc_enter_shift_sec
	wait_time = clamp(new_time, Settings.npc_enter_min_sec, INF)
	$Timers/NPCsTimer.wait_time = wait_time
	$Debug.update_dynamic_labels()

func _on_angries_reached() -> void:
	var life = $Closet.find_item(Item.Type.Life)
	var prompt
	if life == null:
		prompt = Settings.prompts.game_over
		State.current_level = 1
	else:
		prompt = Settings.prompts.used_life
		$Closet.remove_item(life)
	$Modal.show_modal(prompt)

func _on_money_reached() -> void:
	State.current_level += 1
	get_tree().reload_current_scene()

func _on_continue_pressed() -> void:
	await $Modal.hide_modal()
	get_tree().paused = false