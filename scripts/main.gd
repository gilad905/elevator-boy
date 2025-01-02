extends Node

var game_over_prompt: String = "GAME OVER"
var level_up_prompt: String = "LEVEL COMPLETED"
var version_pat = RegEx.create_from_string("\\{version:([^}]*)\\}")
var current_span: int = 1
var span_duration: float

func _ready() -> void:
	span_duration = get_span_duration()
	$Overlay/ColorRect.modulate.a = 0
	$ElevatorEnterTimer.wait_time = Global.elevator_check_interval_sec
	$SpeedSpanTimer.wait_time = span_duration
	$Persons/PersonsTimer.wait_time = Global.person_enter_max_sec
	load_debug_labels()
	# _debug_enter_persons_bug()
	# return

	await get_tree().create_timer(1).timeout
	# _on_money_reached()
	_on_persons_timer_timeout()
	$SpeedSpanTimer.start()
	$Persons/PersonsTimer.start()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("elevator_move_up"):
		$Elevator.move_one_floor(true)
	elif Input.is_action_pressed("elevator_move_down"):
		$Elevator.move_one_floor(false)
	elif Input.is_action_just_pressed("door_toggle"):
		$Elevator._on_door_toggle_pressed()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("time_scale_increase"):
		set_time_scale(true)
	elif event.is_action_pressed("time_scale_decrease"):
		set_time_scale(false)

func set_time_scale(to_increase: bool):
	var time_scale = Engine.get_time_scale()
	var shift = 2.0 if to_increase else 0.5
	time_scale = clamp(time_scale * shift, 0.125, 32.0)
	Engine.set_time_scale(time_scale)
	update_debug_dynamic()

func get_level_times_desc() -> String:
	var shift = (Global.person_enter_max_sec - Global.person_enter_min_sec)
	var span_count = ceil(shift / Global.span_timer_decrease_sec)
	var time_sec = span_count * span_duration
	return "span time: %ss\nmin enter: %s spans, %s min" % [span_duration, span_count, time_sec / 60]

func load_debug_labels() -> void:
	$Debug/Version.text = version_pat.sub($Debug/Version.text, "$1")
	var level_times = get_level_times_desc()
	$Debug/General.text = level_times
	update_debug_dynamic()

func update_debug_dynamic() -> void:
	var args = [$Persons/PersonsTimer.wait_time, Engine.get_time_scale()]
	$Debug/Dynamic.text = "enter interval: %ss\ntime scale: x%s" % args

func show_overlay_and_reload() -> void:
	$Overlay.show()
	var tween = create_tween().tween_property($Overlay/ColorRect, "modulate:a", 1, 1)
	await tween.finished
	Nodes.root.set_process_mode(ProcessMode.PROCESS_MODE_DISABLED)
	get_tree().paused = true
	await get_tree().create_timer(4).timeout

func get_span_duration() -> float:
	var shift = Global.speed_span_level_decrease_sec * (Global.current_level - 1)
	return clamp(Global.speed_span_max_sec - shift, Global.speed_span_min_sec, INF)

func _on_persons_timer_timeout() -> void:
	$Persons.add_random_person()

func _on_door_state_changed(state: int) -> void:
	if state == $Elevator/Door.State.open:
		$Elevator.remove_persons_in_dest()
		_on_elevator_enter_timer_timeout()
		$ElevatorEnterTimer.start()
	elif state == $Elevator/Door.State.closing:
		$ElevatorEnterTimer.stop()

func _on_elevator_enter_timer_timeout():
	var floor_num = $Elevator.current_floor_num
	var _floor = $Floors.get_floor(floor_num)
	_floor.enter_elevator_next()

func _on_speed_span_timer_timeout() -> void:
	current_span += 1
	var wait_time = $Persons/PersonsTimer.wait_time
	var new_time = wait_time - Global.span_timer_decrease_sec
	wait_time = clamp(new_time, Global.person_enter_min_sec, INF)
	$Persons/PersonsTimer.wait_time = wait_time
	update_debug_dynamic()

func _on_angries_reached() -> void:
	$Overlay/ColorRect/Prompt.text = game_over_prompt
	show_overlay_and_reload()

func _on_money_reached() -> void:
	$Overlay/ColorRect/Prompt.text = level_up_prompt
	Global.current_level += 1
	show_overlay_and_reload()

func _on_continue_pressed() -> void:
	Nodes.root.set_process_mode(ProcessMode.PROCESS_MODE_PAUSABLE)
	get_tree().paused = false
	get_tree().reload_current_scene()

func _debug_enter_persons_bug() -> void:
	print(Global._temp)

	for i in 2:
		var dest = 5 if i > 1 else 1
		var person = $Persons.create_person(dest)
		$Elevator.add_person(person)
	# await get_tree().create_timer(10).timeout
	# for i in 2:
	# 	$Persons.add_person_at_floor(5, i + 2)

	$Persons.add_person_at_floor(5, 2)
	await get_tree().create_timer(1.5).timeout
	$Persons.add_person_at_floor(5, 3)
	await get_tree().create_timer(Global._temp + 0.5).timeout
	$Elevator._on_door_toggle_pressed()

	# await get_tree().create_timer(Global._temp + 0.5).timeout
	# $Elevator._on_door_toggle_pressed()
	await get_tree().create_timer(4).timeout
	Global._temp += 0.1

	get_tree().reload_current_scene()
