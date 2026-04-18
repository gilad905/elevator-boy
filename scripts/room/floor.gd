extends Room

var door: Node2D
var right_edge: int
const npc_y: int = 38
const pressed_font_color: Color = Color("4af502")

func _ready() -> void:
	door = Nodes.Elevator.get_node("Door")
	self.npc_limit = 4
	right_edge = get_right_edge()
	npc_start_position = Vector2(right_edge, npc_y)
	$FloorNum.text = str(get_index() + 1)

func get_npc_position(i: int) -> Vector2:
	var spacing: int = Settings.npc_spacing
	var radius: int = Settings.patience_radius
	var x = spacing + (radius * 2 + spacing) * i
	return Vector2(x, npc_y)

func enter_elevator_next():
	# if Env.is_dev:
	# 	print("enter_elevator_next check")

	if $NPCs.get_child_count() == 0:
		return
	var npc = $NPCs.get_child(0)
	if npc.is_moving():
		return
	if door.current_state != door.DoorState.open:
		return
	if not Nodes.Elevator.has_room():
		return

	# if Env.is_dev:
	# 	print("enter_elevator_next passed")

	npc.patience_ended.disconnect(_on_npc_patience_ended)
	Nodes.Elevator.add_npc(npc)
	update_npc_positions()

func _on_npc_movement_finished(_npc: Node2D) -> void:
	var i = _npc.get_index()
	if i == 0:
		enter_elevator_next()

func set_pressed(is_on: bool) -> void:
	if is_on:
		$FloorNumFrame.frame = 1
		$FloorNum.add_theme_color_override("font_color", pressed_font_color)
	else:
		$FloorNumFrame.frame = 0
		$FloorNum.remove_theme_color_override("font_color")

func add_npc(npc) -> void:
	assert(has_room(), name + " is full")
	$NPCs.add_child(npc)
	npc.position = npc_start_position
	super (npc)

func get_right_edge() -> int:
	var _right_edge = $TouchScreenButton.position.x
	_right_edge += $TouchScreenButton.shape.size.x / 2
	_right_edge -= Settings.patience_radius * 2 + 5
	return _right_edge

func _on_npc_patience_ended(npc: Node2D) -> void:
	if npc is Person:
		update_hud_by_result(0, 1)
		var removed = npc.remove(Npc.RemovalType.Fade)
		npc.show_result(false)
		await removed
	elif npc.type == Npc.Type.Bomb:
		await bomb_explode()
	update_npc_positions()

func _on_touched() -> void:
	Nodes.Elevator.go_to_floor(get_index() + 1)
