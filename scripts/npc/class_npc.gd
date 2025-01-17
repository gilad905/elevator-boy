class_name Npc extends Node2D

signal patience_ended(npc: Node2D)

const zero_angle: float = PI * -0.5
const full_angle: float = PI * 1.5
enum Type {Person, Bomb, Businessman}

static var radius = Global.patience_radius
static var circle_center = Vector2.ONE * radius

var type: Type
var patience_sec: int = -1
var face_steps_sec: Array = []
var is_patience_ended: bool = false
var patience_tween: Tween
var movement_tween: Tween
var current_angle: float = zero_angle
var _showing_end: bool = false
var to_animate: AnimatedSprite2D

func _init() -> void:
	patience_sec = Global.npc_meta[type].patience_sec
	for percent in [50, 75]:
		face_steps_sec.append(patience_sec * percent / 100.0)

func _ready() -> void:
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
	to_animate.frame = 3
	is_patience_ended = true

func redraw_patience(angle: float) -> void:
	current_angle = angle
	queue_redraw()

func move_to(_position):
	var duration = position.distance_to(_position) / Global.npc_speed
	movement_tween = create_tween()
	movement_tween.tween_property(self, "position", _position, duration)
	await movement_tween.finished

func is_moving() -> bool:
	return movement_tween and movement_tween.is_running()

func init_end() -> void:
	_showing_end = true
	patience_tween.stop()

func remove() -> Signal:
	init_end()
	var ended = fade_out().finished
	ended.connect(_remove_node)
	return ended

func fade_out() -> Tween:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, Global.npc_result_sec)
	return tween

func _remove_node() -> void:
	get_parent().remove_child(self)
	self.queue_free()
