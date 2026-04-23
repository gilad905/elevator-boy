extends Node

var span_duration: float
var start_enter_interval: float
var current_span: int = 1
var modal

signal angries_reached
signal money_reached
signal npcs_timer_timeout

func _ready() -> void:
	angries_reached.connect(_on_angries_reached)
	money_reached.connect(_on_money_reached)
	npcs_timer_timeout.connect(_on_npcs_timer_timeout)
	
	modal = $Foreground/Modal

	if State.show_welcome_screen:
		State.show_welcome_screen = false
		# if Env.is_dev:
		# 	print("DEV - setting current_level to 2")
		# 	State.current_level = 2
		var choice = await modal.show_modal("welcome")
		if choice == "NewGame":
			State.reset()
			State.save()
			await modal.show_modal("introduction")
	LevelManager.init_level(angries_reached, money_reached, npcs_timer_timeout)
	$Debug.load_labels()
	await modal.show_modal("start_level", "LEVEL %d\nGET READY" % State.current_level)
	await get_tree().create_timer(1, false).timeout
	LevelManager.start_level()

func _input(event: InputEvent) -> void:
	if Env.is_dev:
		if event.is_action_pressed("time_scale_increase"):
			print("DEV - increasing time scale")
			_set_time_scale(true)
		elif event.is_action_pressed("time_scale_decrease"):
			print("DEV - decreasing time scale")
			_set_time_scale(false)

func _set_time_scale(to_increase: bool):
	var time_scale = Engine.get_time_scale()
	var shift = 2.0 if to_increase else 0.5
	time_scale = clamp(time_scale * shift, 0.125, 32.0)
	Engine.set_time_scale(time_scale)
	$Debug.update_dynamic_labels()

func _goto_next_level() -> void:
	State.current_level += 1
	State.save()
	get_tree().reload_current_scene()

func _pause() -> void:
	if modal.visible:
		return
	var choice = await modal.show_modal("paused")
	if choice == "NewGame":
		State.reset()
		State.save()
		get_tree().reload_current_scene()

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
	LevelManager.end_level()
	var life = $Closet.find_item(Item.Type.Life)
	var modal_name
	if life == null:
		modal_name = "game_over"
		State.reset()
		State.save()
	else:
		modal_name = "used_life"
		$Closet.remove_item(life)
		State.angry_count = 0
		State.save()
	await modal.show_modal(modal_name)
	get_tree().reload_current_scene()

func _on_money_reached() -> void:
	await get_tree().create_timer(0.8).timeout
	await $Audio.play_sound("Tada")
	_goto_next_level()

func _on_pause_pressed() -> void:
	_pause()
