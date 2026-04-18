extends Item

const SWEEP_FRAMES = preload("res://assets/animations/broom_sweep.tres")
var anim_duration = 0.0

func _ready() -> void:
	anim_duration = SWEEP_FRAMES.get_frame_count("default") / SWEEP_FRAMES.get_animation_speed("default")

func _on_pressed() -> void:
	# needs to call activate() for super.activate()
	activate()

func activate() -> void:
	var rooms = _get_affected_rooms()
	var elevator_only = rooms.size() == 1
	_show_animation(elevator_only)

	await get_tree().create_timer(.5).timeout
	for room: Room in rooms:
		for npc: Npc in room.get_node("NPCs").get_children():
			_sweep_npc(npc)

	if Env.is_dev:
		print("DEV - not removing broom")
	else:
		super ()

func _show_animation(elevator_only: bool) -> void:
	var x_end = 50 if elevator_only else 300

	var anim = AnimatedSprite2D.new()
	anim.sprite_frames = SWEEP_FRAMES
	anim.position = Vector2(5, 28)
	anim.scale = Vector2(.35, .35)
	Nodes.Elevator.add_child(anim)

	var tween = anim.create_tween()
	tween.tween_property(anim, "position:x", x_end, anim_duration).as_relative()
	anim.play()
	anim.animation_finished.connect(anim.queue_free)

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
