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
	Funcs.fly_node_to(npc, _position, Settings.npc_speed)

func update_npc_positions() -> void:
	for npc in $NPCs.get_children():
		update_npc_position(npc)

func has_room() -> bool:
	return $NPCs.get_child_count() < npc_limit

func update_hud_by_result(happy_count: int, angry_count: int) -> void:
	var money_shift = 0
	if happy_count > 0:
		var happy_money = Settings.money_by_happy_count[happy_count]
		money_shift += happy_money
	if angry_count > 0:
		var angry_money = Settings.angry_money_loss * angry_count
		Nodes.HUD.increment_angries(angry_count)
		money_shift -= angry_money
	if money_shift != 0:
		Nodes.HUD.increment_money(money_shift)

func bomb_explode() -> Signal:
	var removed: Signal
	var angry_count = 0
	for npc in $NPCs.get_children():
		if npc.type == Npc.Type.Bomb:
			var exploded = npc.show_explode()
			if not removed:
				removed = exploded
		elif npc is Person:
			angry_count += 1
			removed = npc.remove(Npc.RemovalType.Fall)
			npc.show_result(false)
	update_hud_by_result(0, angry_count)
	return removed

func _on_npc_patience_ended(npc: Node2D) -> void:
	if npc.type == Npc.Type.Bomb:
		await bomb_explode()
		update_npc_positions()
