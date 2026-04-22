extends Node

var span_duration: float
var start_enter_interval: float
var current_span: int = 1
var modal

func _ready() -> void:
	modal = $Foreground/Modal
	if State.on_welcome_screen:
		State.on_welcome_screen = false
		# if Env.is_dev:
		# 	print("DEV - setting current_level to 2")
		# 	State.current_level = 2
		var choice = await modal.show_modal(Settings.modal_meta.welcome)
		if choice == "new_game":
			State.reset()
			State.save()
			await modal.show_modal(Settings.modal_meta.introduction)
	init_level()
	$Debug.load_labels()
	await modal.show_dynamic("LEVEL %d - GET READY" % State.current_level)
	await get_tree().create_timer(1, false).timeout
	start_level()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		pause()
	elif Env.is_dev:
		if event.is_action_pressed("time_scale_increase"):
			print("DEV - increasing time scale")
			set_time_scale(true)
		elif event.is_action_pressed("time_scale_decrease"):
			print("DEV - decreasing time scale")
			set_time_scale(false)

func init_level() -> void:
	for _floor in $Floors.get_children():
		_floor.angries_reached.connect(_on_angries_reached)
		_floor.money_reached.connect(_on_money_reached)
	$Closet.load_from_state()
	span_duration = get_speed_span_duration()
	start_enter_interval = get_start_enter_interval()
	NPCs.update_frequencies()
	# print("angry_count: %d" % State.angry_count)
	$HUD/Angries/Amount.text = str(State.angry_count)
	$Timers/SpeedSpanTimer.wait_time = span_duration
	$Timers/NPCsTimer.wait_time = start_enter_interval

func start_level() -> void:
	_on_npcs_timer_timeout()
	$Timers/NPCsTimer.start()
	$Timers/SpeedSpanTimer.start()
	$Audio.play_music("Bossa-radio-1")

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
		$Floors.enter_elevator_next()

func _on_speed_span_timer_timeout() -> void:
	current_span += 1
	var wait_time = $Timers/NPCsTimer.wait_time
	var new_time = wait_time - Settings.npc_enter_shift_sec
	wait_time = clamp(new_time, Settings.npc_enter_min_sec, INF)
	$Timers/NPCsTimer.wait_time = wait_time
	$Debug.update_dynamic_labels()

func _on_angries_reached() -> void:
	var life = $Closet.find_item(Item.Type.Life)
	var modal_meta
	if life == null:
		modal_meta = Settings.modal_meta.game_over
		State.reset()
		State.save()
	else:
		modal_meta = Settings.modal_meta.used_life
		$Closet.remove_item(life)
		State.angry_count = 0
		State.save()
	await modal.show_modal(modal_meta)
	get_tree().reload_current_scene()

func _on_money_reached() -> void:
	await get_tree().create_timer(0.8).timeout
	await $Audio.play_sound("Tada")
	goto_next_level()

func goto_next_level() -> void:
	State.current_level += 1
	State.save()
	get_tree().reload_current_scene()

func pause() -> void:
	if modal.visible:
		return
	var choice = await modal.show_modal(Settings.modal_meta.paused)
	if choice == "new_game":
		State.reset()
		State.save()
		get_tree().reload_current_scene()
