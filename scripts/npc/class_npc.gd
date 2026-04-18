class_name Npc extends Node2D

signal patience_ended(npc: Node2D)

const zero_angle: float = PI * -0.5
const full_angle: float = PI * 1.5
const result_duration: float = Settings.npc_result_duration
const fall_duration: float = Settings.npc_fall_duration
enum Type {Unset, Person, Bomb, Businessman}
enum RemovalType {Fade, Fall}

static var radius = Settings.patience_radius
static var circle_center = Vector2.ZERO

var type: Type = Type.Unset
var fall_y: int
var patience_sec: int = -1
var face_steps_sec: Array = []
var is_patience_ended: bool = false
var patience_tween: Tween
var movement_tween: Tween
var current_angle: float = zero_angle
var _showing_end: bool = false
var to_animate: AnimatedSprite2D

func _init() -> void:
	patience_sec = Settings.npc_meta[type].patience_sec
	for percent in [50, 75]:
		face_steps_sec.append(patience_sec * percent / 100.0)

func _ready() -> void:
	fall_y = get_viewport().size.y - Nodes.Floors.get_floor(5).global_position.y
	start_patience_tween()

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, zero_angle, current_angle, 64, Color.RED, 2)

func start_patience_tween() -> void:
	patience_tween = create_tween()
	patience_tween.set_parallel()
	patience_tween.tween_method(redraw_patience, zero_angle, full_angle, patience_sec)
	for i in face_steps_sec.size():
		var delay = face_steps_sec[i]
		var callback = to_animate.set_frame.bind(i + 1)
		patience_tween.tween_callback(callback).set_delay(delay)
	await patience_tween.finished
	patience_ended.emit(self )
	to_animate.frame = 3
	is_patience_ended = true

func redraw_patience(angle: float) -> void:
	current_angle = angle
	queue_redraw()

func is_moving() -> bool:
	return movement_tween and movement_tween.is_running()

func init_showing_end() -> void:
	_showing_end = true
	patience_tween.stop()

func remove(_type: RemovalType = RemovalType.Fade) -> Signal:
	init_showing_end()
	var tween
	match _type:
		RemovalType.Fade:
			tween = fade_out()
		RemovalType.Fall:
			tween = fall()
	tween.finished.connect(_remove_node)
	return tween.finished

func fade_out() -> Tween:
	var tween = create_tween()
	tween.tween_property(self , "modulate:a", 0, result_duration)
	return tween

func fall() -> Tween:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self , "position:y", fall_y, fall_duration).as_relative() \
		.set_trans(Tween.TRANS_BACK)	
	var _x = _randi_range_signed(50, 300)
	var _rotation = _randi_range_signed(50, 200)
	tween.tween_property(self , "position:x", _x, fall_duration).as_relative()
	tween.tween_property(self , "rotation_degrees", _rotation, fall_duration).as_relative()
	return tween

func _remove_node() -> void:
	get_parent().remove_child(self )
	self.queue_free()

func _randi_range_signed(_min: int, _max: int) -> int:
	return randi_range(_min, _max) * (1 if randi() % 2 == 0 else -1)
