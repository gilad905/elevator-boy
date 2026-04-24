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

func _get_npcs_money_loss(npcs) -> int:
	var money_loss = 0
	for npc in npcs:
		var meta = Settings.npc_meta[npc.type]
		if meta.has("money_loss"):
			money_loss += meta.money_loss
	return money_loss

func apply_npc_results(npcs) -> void:
	var happies = npcs.filter(func(npc): return not npc.is_patience_ended)
	var angries = npcs.filter(func(npc): return npc.is_patience_ended)
	play_happy_sounds(happies.size())

	var money_gain = Settings.money_by_happy_count[happies.size()]
	var money_loss = _get_npcs_money_loss(angries)
	var money_shift = money_gain - money_loss
	if money_shift != 0:
		Nodes.HUD.increment_money(money_shift)
		if State.money_count >= Settings.win_on_amount:
			money_reached.emit()

	if angries.size() > 0:
		Nodes.HUD.increment_angries(angries.size())
		if State.angry_count >= Settings.lose_on_angries:
			angries_reached.emit()

func play_happy_sounds(happy_count: int) -> void:
	for i in happy_count:
		Nodes.AudioManager.play_sound("Kaching")
		await get_tree().create_timer(0.2).timeout

func bomb_explode() -> Signal:
	var removed: Signal
	var npcs = $NPCs.get_children()
	var persons = []
	for npc in npcs:
		if npc.type == Npc.Type.Bomb:
			var exploded = npc.show_explode()
			if not removed:
				removed = exploded
		elif npc is Person:
			npc.is_patience_ended = true
			removed = npc.remove(Npc.RemovalType.Fall)
			npc.show_result(false)
			persons.append(npc)
	if persons.size() > 0:
		apply_npc_results(persons)
	return removed

func _on_npc_patience_ended(npc: Node2D) -> void:
	if npc.type == Npc.Type.Bomb:
		await bomb_explode()
		update_npc_positions()
