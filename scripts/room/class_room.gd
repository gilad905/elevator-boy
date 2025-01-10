class_name Room extends Node2D

var npc_limit: int = 0
var npc_start_position: Vector2

func add_npc(npc) -> void:
	npc.patience_ended.connect(_on_npc_patience_ended)
	update_npc_position(npc)

func get_npc_position(_i: int) -> Vector2:
	return Vector2.ZERO

func update_npc_position(npc: Node2D):
	var i = npc.get_index()
	var _position = get_npc_position(i)
	# if name == "Elevator":
	# 	Funcs._print("moving %s at %s to %s" % [npc, i, _position])
	npc.move_to(_position)

func update_npc_positions() -> void:
	for npc in $NPCs.get_children():
		update_npc_position(npc)

func has_room() -> bool:
	return $NPCs.get_child_count() < npc_limit

func remove_person(person: Node2D, is_happy: bool) -> Signal:
	person.patience_ended.disconnect(_on_npc_patience_ended)
	var ended = person.end_with_result(is_happy)
	ended.connect(_remove_npc_node.bind(person))
	return ended

func remove_bomb(bomb: Node2D) -> Signal:
	bomb.patience_ended.disconnect(_on_npc_patience_ended)
	var ended = bomb.explode()
	ended.connect(_remove_npc_node.bind(bomb))
	return ended

func update_hud_by_result(happy_count: int, angry_count: int) -> void:
	var money_shift = 0
	if happy_count > 0:
		var happy_money = Global.money_by_happy_count[happy_count]
		money_shift += happy_money
	if angry_count > 0:
		var angry_money = Global.angry_money_loss * angry_count
		Nodes.HUD.increment_angries(angry_count)
		money_shift -= angry_money
	if money_shift != 0:
		Nodes.HUD.increment_money(money_shift)

func bomb_explode() -> Signal:
	var removed
	var angry_count = 0
	for npc in $NPCs.get_children():
		if npc.npc_type == Npc.Type.Bomb:
			removed = remove_bomb(npc)
		elif npc.npc_type == Npc.Type.Person:
			angry_count += 1
			remove_person(npc, false)
	update_hud_by_result(0, angry_count)
	return removed

func _on_npc_patience_ended(npc: Node2D) -> void:
	if npc.npc_type == Npc.Type.Bomb:
		await bomb_explode()
		update_npc_positions()

func _remove_npc_node(npc: Node2D) -> void:
	$NPCs.remove_child(npc)
	npc.queue_free()
