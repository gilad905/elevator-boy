extends Item

func _on_pressed() -> void:
	# needs to call activate() for super.activate()
	activate()

func activate() -> void:
	var rooms = [Nodes.Elevator]
	var floor_num = Nodes.Elevator.current_floor_num
	if floor_num != Nodes.Elevator.MOVING:
		var _floor = Nodes.Floors.get_floor(floor_num)
		rooms.append(_floor)

	for room: Room in rooms:
		for npc: Npc in room.get_node("NPCs").get_children():
			npc.remove(Npc.RemovalType.Fall)
			if npc is Person:
				npc.get_node("Face").play("shock")
			
	super()
