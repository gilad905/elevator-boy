extends Node2D

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
	# 	Global._print("moving %s at %s to %s" % [npc, i, _position])
	npc.move_to(_position)

func update_npc_positions() -> void:
	for npc in $NPCs.get_children():
		update_npc_position(npc)

func has_room() -> bool:
	return $NPCs.get_child_count() < npc_limit

func remove_npc(npc: Node2D, is_happy: bool):
	npc.patience_ended.disconnect(_on_npc_patience_ended)
	# Global._print("starting remove %s" % npc)
	var removed = npc.remove_with_result(is_happy)
	removed.connect(_remove_npc_node.bind(npc))
	return removed

func _on_npc_patience_ended(_npc: Node2D) -> void:
	if _npc.npcType == Global.NpcType.bomb:
		for npc in $NPCs.get_children():
			if npc.npcType != Global.NpcType.bomb:
				npc.remove_npc(false)

func _remove_npc_node(npc: Node2D) -> void:
	# Global._print("removing node %s" % npc)
	$NPCs.remove_child(npc)
	npc.queue_free()
