class_name Room extends Node2D

signal money_reached
signal angries_reached

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
	npc.movement_tween = Funcs.fly_node_to(npc, _position, Settings.npc_speed)
	npc.movement_tween.finished.connect(_on_npc_movement_finished.bind(npc))

func _on_npc_movement_finished(_npc: Node2D) -> void:
	# implemented in floor.gd
	pass

func update_npc_positions() -> void:
	for npc in $NPCs.get_children():
		update_npc_position(npc)

func has_room() -> bool:
	return $NPCs.get_child_count() < npc_limit

func apply_npc_results(happy_count: int, angry_count: int) -> void:
	play_happy_sounds(happy_count)
	var money_shift = 0
	if happy_count > 0:
		var happy_money = Settings.money_by_happy_count[happy_count]
		money_shift += happy_money
	if angry_count > 0:
		var angry_money = Settings.angry_money_loss * angry_count
		money_shift -= angry_money
		var new_angries = Nodes.HUD.increment_angries(angry_count)
		State.angry_count = new_angries
		if new_angries >= Settings.lose_on_angries:
			angries_reached.emit()
	if money_shift != 0:
		var new_money = Nodes.HUD.increment_money(money_shift)
		if new_money >= Settings.win_on_amount:
			money_reached.emit()

func play_happy_sounds(happy_count: int) -> void:
	for i in happy_count:
		Nodes.Audio.play_sound("Kaching")
		await get_tree().create_timer(0.2).timeout

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
	apply_npc_results(0, angry_count)
	return removed

func _on_npc_patience_ended(npc: Node2D) -> void:
	if npc.type == Npc.Type.Bomb:
		await bomb_explode()
		update_npc_positions()
