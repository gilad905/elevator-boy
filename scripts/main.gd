extends Node

var modal

signal angries_reached
signal money_reached
signal npcs_timer_timeout

func _ready() -> void:
	angries_reached.connect(_on_angries_reached)
	money_reached.connect(_on_money_reached)
	npcs_timer_timeout.connect(_on_npcs_timer_timeout)
	modal = $Foreground/Modal

	if State.show_welcome_modal:
		State.show_welcome_modal = false
		var choice = await modal.show_modal("welcome")
		if choice == "NewGame":
			State.reset()
			await modal.show_modal("introduction")
		# if Env.is_dev:
		# 		print("DEV - setting hardcoded current_level")
		# 		State.current_level = 10
	LevelManager.init_level(angries_reached, money_reached, npcs_timer_timeout)
	$Debug.load_labels()
	await modal.show_modal("start_level", "LEVEL %d\nGET READY" % State.current_level)
	await get_tree().create_timer(.6, false).timeout
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

func _on_npcs_timer_timeout() -> void:
	NPCs.add_random_npc()

func _on_door_state_changed(state: int) -> void:
	if state == $Elevator/Door.DoorState.open:
		$Elevator.remove_persons_in_dest()
		$Floors.enter_elevator_next()

func _on_angries_reached() -> void:
	LevelManager.end_level()
	var life = $Closet.find_item(Item.Type.Life)
	if life == null:
		await modal.show_modal("game_over")
		State.reset()
	else:
		$Closet.remove_item(life)
		State.angry_count = 0
		State.save()
		var choice = await modal.show_modal("used_life")
		if choice == "NewGame":
			State.reset()
	get_tree().reload_current_scene()

func _on_money_reached() -> void:
	LevelManager.end_level()
	$AudioManager.play_sound("Tada")
	await modal.show_popup("win", 2, str(State.money_count))
	_goto_next_level()

func _on_pause_pressed() -> void:
	if modal.visible:
		return
	var choice = await modal.show_modal("paused")
	if choice == "NewGame":
		State.reset()
		get_tree().reload_current_scene()