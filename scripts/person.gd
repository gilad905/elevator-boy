extends Area2D

signal patience_ended(person: Node2D)

var dest: int = -1
var is_moving: bool = false
var is_patience_ended: bool = false
var patience_tween: Tween
var speed: float

var radius = Global.person_radius
var circle_center = Vector2.ONE * radius
var zero_angle: float = PI * -0.5
var full_angle: float = PI * 1.5
# var angle_third: float = (full_angle - zero_angle) / 3
var current_angle: float = 0

func _ready() -> void:
	speed = get_node("/root/Main/Persons").move_speed
	start_patience_tween()

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, zero_angle, current_angle, 64, Color.RED, 2)

func start_patience_tween() -> void:
	var patience_sec = get_node("/root/Main/Persons").patience_sec
	patience_tween = create_tween()
	patience_tween.tween_method(redraw_patience, zero_angle, full_angle, patience_sec)
	patience_tween.tween_callback(_on_patience_ended)

# func add_to_patience(secs: float):
# 	patience_tween

func redraw_patience(angle: float) -> void:
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

func _on_patience_ended() -> void:
	is_patience_ended = true
	patience_ended.emit(self)
