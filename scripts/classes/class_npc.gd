extends Node2D

signal patience_ended(person: Node2D)

const zero_angle: float = PI * -0.5
const full_angle: float = PI * 1.5

static var radius = Global.patience_radius
static var circle_center = Vector2.ONE * radius

var is_patience_ended: bool = false
var patience_tween: Tween
var movement_tween: Tween
var current_angle: float = 0

func _ready() -> void:
	start_patience_tween()
	# _debug_test_result(true)

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, zero_angle, current_angle, 64, Color.RED, 2)

func start_patience_tween() -> void:
	patience_tween = create_tween()
	patience_tween.tween_method(redraw_patience, zero_angle, full_angle, Global.patience_sec)
	await patience_tween.finished
	is_patience_ended = true
	patience_ended.emit(self)

func redraw_patience(angle: float) -> void:
	current_angle = angle
	queue_redraw()

func move_to(_position):
	var duration = position.distance_to(_position) / Global.npc_speed
	movement_tween = create_tween()
	movement_tween.tween_property(self, "position", _position, duration)
	await movement_tween.finished

func remove() -> void:
	patience_tween.stop()

func is_moving() -> bool:
	return movement_tween and movement_tween.is_running()