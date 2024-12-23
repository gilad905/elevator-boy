extends Area2D

signal timeout_reached(person: Area2D)

var dest: int = -1
var radius = Global.person_radius
var circle_center = Vector2(radius, radius)
var zero_angle: float = PI * -0.5
var full_angle: float = PI * 1.5
var current_angle: float = 0

func _ready() -> void:
	init_timeout_tween()

func init_timeout_tween() -> void:
	var timeout_sec = get_node("/root/Main/Persons").timeout_sec
	var tween = create_tween()
	tween.tween_method(redraw_timeout, zero_angle, full_angle, timeout_sec)
	tween.tween_callback(timeout_reached.emit.bind(self))

func redraw_timeout(angle: float) -> void:
	current_angle = angle
	queue_redraw()

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, PI * -0.5, current_angle, 64, Color.RED, 2)

func set_dest(_dest: int) -> void:
	dest = _dest
	$Label.text = str(_dest)
