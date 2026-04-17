extends Item

const SWEEP_FRAMES = preload("res://assets/animations/broom_sweep.tres")

func _on_pressed() -> void:
	# needs to call activate() for super.activate()
	activate()

func activate() -> void:
	_show_animation()

	var rooms = _get_affected_rooms()
	for room: Room in rooms:
		for npc: Npc in room.get_node("NPCs").get_children():
			_sweep_npc(npc)
			
	super ()

func _show_animation() -> void:
	var anim = AnimatedSprite2D.new()
	anim.position.x = Nodes.Elevator.global_position.x + 150
	anim.position.y = Nodes.Elevator.global_position.y + 30
	anim.sprite_frames = SWEEP_FRAMES
	Nodes.Foreground.add_child(anim)
	anim.scale = Vector2(.4, .4)
	var tween = anim.create_tween()
	var duration = anim.sprite_frames.get_frame_count("default") / anim.sprite_frames.get_animation_speed("default")
	tween.tween_property(anim, "position:x", 50, duration).as_relative()
	anim.animation_finished.connect(anim.queue_free, CONNECT_ONE_SHOT)
	anim.play()

func _sweep_npc(npc: Npc) -> void:
	npc.remove(Npc.RemovalType.Fall)
	if npc is Person:
		npc.get_node("Face").play("shock")


func _get_affected_rooms() -> Array:
	var rooms = [Nodes.Elevator]
	var floor_num = Nodes.Elevator.current_floor_num
	if floor_num != Nodes.Elevator.MOVING:
		var _floor = Nodes.Floors.get_floor(floor_num)
		rooms.append(_floor)
	return rooms
