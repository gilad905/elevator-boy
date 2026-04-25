extends Room

const MOVING: int = -1
var current_floor_num: int = MOVING
var npcs_offset: Vector2
var inner_size: Vector2

func _ready() -> void:
	self.npc_limit = 4
	current_floor_num = Settings.floor_count
	Nodes.Floors.set_floor_pressed(current_floor_num)
	inner_size.x = $Frame.points[0].x - $Frame.points[1].x - $Frame.width
	inner_size.y = $Frame.points[3].y - $Frame.points[0].y - $Frame.width
	npcs_offset = Vector2.ONE * ($Frame.width / 2 - Settings.npc_patience_radius)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("elevator_move_up"):
		move_one_floor(true)
	elif Input.is_action_pressed("elevator_move_down"):
		move_one_floor(false)
	elif Input.is_action_just_pressed("door_toggle"):
		_on_door_toggle_pressed()

func go_to_floor(floor_num: int) -> void:
	if floor_num == current_floor_num:
		$Door.toggle_state()
		return

	Nodes.Floors.set_floor_pressed(floor_num)
	if $Door.current_state != $Door.DoorState.closed:
		$Door.set_state($Door.DoorState.closing)
		await $Door.has_closed

	current_floor_num = MOVING
	await $Mover.move_to(floor_num)
	current_floor_num = floor_num
	$Door.set_state($Door.DoorState.opening)

func move_one_floor(go_up: bool) -> void:
	var target_floor: int = current_floor_num + (1 if go_up else -1)
	if Nodes.Floors.floor_exists(target_floor):
		go_to_floor(target_floor)

func get_npc_position(i: int) -> Vector2:
	var _position = Vector2.ZERO
	_position.x += 1 if i % 2 else 0
	_position.y += 1 if i > 1 else 0
	_position = npcs_offset + inner_size / 4 * (_position * 2 + Vector2.ONE)
	return _position

func remove_persons_in_dest() -> void:
	var removed: Signal
	var removed_persons = []
	for npc in $NPCs.get_children():
		if not npc is Person:
			continue
		if npc.dest == current_floor_num:
			var is_happy = not npc.is_patience_ended
			removed = npc.remove(Npc.RemovalType.Fade)
			npc.show_result(is_happy)
			removed_persons.append(npc)
	if removed_persons.size() > 0:
		apply_npc_results(removed_persons)
	if removed:
		await removed
		Nodes.Floors.enter_elevator_next()
		update_npc_positions()

func apply_npc_results(npcs) -> void:
	super(npcs)
	var happies = npcs.filter(func(npc): return not npc.is_patience_ended)
	if happies.size() > 0:
		var happy_money = Settings.money_by_happy_count[happies.size()]
		show_happy_floater(happy_money)

func show_happy_floater(money: int) -> void:
	$HappyFloater/Amount.text = "x" + str(money)
	$HappyFloater.show()
	await NPCs.tween_floater($HappyFloater)
	$HappyFloater.hide()

func add_npc(npc) -> void:
	# Funcs._print("adding %s of %s" % [npc, NPCs.get_child_count()])
	assert(has_room(), name + " is full")
	if npc.get_parent():
		npc.reparent($NPCs)
	else:
		$NPCs.add_child(npc)
	super(npc)

func _on_door_toggle_pressed() -> void:
	if current_floor_num != MOVING:
		$Door.toggle_state()

func _on_npc_movement_finished(_npc: Node2D) -> void:
	Nodes.Floors.enter_elevator_next()

func activate_engine() -> void:
	# Nodes.AudioManager.play_sound("engine")
	$Mover.activate_engine()
	$Door.activate_engine()