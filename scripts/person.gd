extends Area2D

signal patience_ended(person: Node2D)

var dest: int = -1
var is_moving: bool = false
var is_patience_ended: bool = false
var patience_tween: Tween
var speed: float

var patience_sec: int
var radius = Global.person_radius
var circle_center = Vector2.ONE * radius
var zero_angle: float = PI * -0.5
var full_angle: float = PI * 1.5
# var angle_third: float = (full_angle - zero_angle) / 3
var current_angle: float = 0
const timeout_reached_duration: float = 1

func _ready() -> void:
	patience_sec = get_node("/root/Main/Persons").patience_sec
	speed = get_node("/root/Main/Persons").move_speed
	start_patience_tween()

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, zero_angle, current_angle, 64, Color.RED, 2)

func start_patience_tween() -> void:
	patience_tween = create_tween()
	patience_tween.tween_method(redraw_patience, zero_angle, full_angle, patience_sec)
	add_patience_face_timer(50, "angry_1")
	add_patience_face_timer(75, "angry_2")
	await patience_tween.finished
	is_patience_ended = true
	patience_ended.emit(self)
	$Face.play("angry_3")

# func add_to_patience(secs: float):
# 	patience_tween

func add_patience_face_timer(percent: int, state: String) -> void:
	var sec = patience_sec * percent / 100.0
	await get_tree().create_timer(sec).timeout
	$Face.play(state)

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

func show_patience_ended(is_happy: bool):
	var face_animation = "happy" if is_happy else "angry_3"
	var mark_animation = "v" if is_happy else "x"
	var new_scale = $Checkmark.scale.x * 2

	patience_tween.stop()
	$Face.play(face_animation)
	$Checkmark.play(mark_animation)
	$Label.hide()
	$Checkmark.show()

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, timeout_reached_duration)
	for type in ["x", "y"]:
		tween.tween_property($Checkmark, "scale:" + type, new_scale, timeout_reached_duration)
	tween.finished.connect(get_parent().remove_child.bind(self))
	tween.finished.connect(queue_free)

	return tween