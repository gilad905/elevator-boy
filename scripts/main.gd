extends Node2D

var game_over_prompt: String = "GAME OVER\nYOU'RE IN %s$ DEBT\nYOU REACHED LEVEL %s"
var current_level = 1
var version_pat = RegEx.create_from_string("\\{version:([^}]*)\\}")

func _ready() -> void:
	$ElevatorEnterTimer.wait_time = Global.elevator_check_interval_sec
	$LevelUpTimer.wait_time = Global.level_up_interval_sec
	$Persons/PersonsTimer.wait_time = Global.person_enter_max_sec
	load_debug_labels()

	await get_tree().create_timer(1).timeout
	_on_persons_timer_timeout()
	$LevelUpTimer.start()
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
	$HUD/TimeScale.text = str(time_scale)

func get_level_times_desc() -> String:
	var shift = (Global.person_enter_max_sec - Global.person_enter_min_sec)
	var level_count = ceil(shift / Global.level_timer_decrease_sec)
	var time_sec = level_count * Global.level_up_interval_sec
	return "min enter: %s levels, %s minutes" % [level_count, time_sec / 60]

func load_debug_labels() -> void:
	$Debug/Version.text = version_pat.sub($Debug/Version.text, "$1")
	var level_times = get_level_times_desc()
	$Debug/Other.text = level_times
	var wait_time = $Persons/PersonsTimer.wait_time
	$Debug/RealTime.text = "enter interval: %s" % wait_time

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

func _on_debt_reached() -> void:
	$OverlayPrompt.text = game_over_prompt % [-Global.lose_on_debt, current_level]
	$OverlayPrompt.show()
	var tween = create_tween().tween_property(self, "modulate", Color("4f4f4f"), 1)
	await tween.finished
	get_node("/root").set_process_mode(ProcessMode.PROCESS_MODE_DISABLED)
	get_tree().paused = true
	await get_tree().create_timer(4).timeout
	get_node("/root").set_process_mode(ProcessMode.PROCESS_MODE_PAUSABLE)
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_level_up_timer_timeout() -> void:
	current_level += 1
	$HUD/Level.text = str(current_level)
	var wait_time = $Persons/PersonsTimer.wait_time
	wait_time = clamp(wait_time - Global.level_timer_decrease_sec, Global.person_enter_min_sec, INF)
	$Debug/RealTime.text = "enter interval: %s" % wait_time
	$Persons/PersonsTimer.wait_time = wait_time
