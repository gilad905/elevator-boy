extends Area2D

signal timeout_reached(person: Node2D)

var dest: int = -1
var is_moving: bool = false
var is_timeout_reached: bool = false
var timeout_tween: Tween
var speed: float

var radius = Global.person_radius
var circle_center = Vector2(radius, radius)
var zero_angle: float = PI * -0.5
var full_angle: float = PI * 1.5
var current_angle: float = 0

func _ready() -> void:
	speed = get_node("/root/Main/Persons").move_speed
	init_timeout_tween()

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, zero_angle, current_angle, 64, Color.RED, 2)

func init_timeout_tween() -> void:
	var timeout_sec = get_node("/root/Main/Persons").timeout_sec
	timeout_tween = create_tween()
	timeout_tween.tween_method(redraw_timeout, zero_angle, full_angle, timeout_sec)
	timeout_tween.tween_callback(_on_timeout_reached)

# func add_to_timeout(secs: float):
# 	timeout_tween

func redraw_timeout(angle: float) -> void:
	current_angle = angle
	queue_redraw()

func move_to(_position):
	var tween = create_tween()
	var duration = position.distance_to(_position) / speed
	is_moving = true
	tween.tween_property(self, "position", _position, duration)
	await tween.finished
	is_moving = false

func set_dest(_dest: int) -> void:
	dest = _dest
	$Label.text = str(_dest)

func _on_timeout_reached() -> void:
	is_timeout_reached = true
	timeout_reached.emit(self)
