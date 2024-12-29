extends Node2D

signal patience_ended(person: Node2D)

const happy_result = preload("res://scenes/happy_result.tscn")
const angry_result = preload("res://scenes/angry_result.tscn")
const patience_ended_tween_duration: float = 1
const zero_angle: float = PI * -0.5
const full_angle: float = PI * 1.5

var dest: int = -1
var is_moving: bool = false
var is_patience_ended: bool = false
var patience_tween: Tween

var radius = Global.person_radius
var circle_center = Vector2.ONE * radius
var current_angle: float = 0
var face_timers = []

func _ready() -> void:
	start_patience_tween()
	# _debug_test_result(true)

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, zero_angle, current_angle, 64, Color.RED, 2)

func start_patience_tween() -> void:
	patience_tween = create_tween()
	patience_tween.tween_method(redraw_patience, zero_angle, full_angle, Global.person_patience_sec)
	add_face_timer(50, "angry_1")
	add_face_timer(75, "angry_2")
	await patience_tween.finished
	is_patience_ended = true
	patience_ended.emit(self)
	$Face.play("angry_3")

func add_face_timer(percent: int, state: String) -> void:
	var sec = Global.person_patience_sec * percent / 100.0
	var timer = get_tree().create_timer(sec)
	timer.timeout.connect($Face.play.bind(state))
	face_timers.append(timer)

func redraw_patience(angle: float) -> void:
	current_angle = angle
	queue_redraw()

func move_to(_position):
	var tween = create_tween()
	var duration = position.distance_to(_position) / Global.person_move_speed
	is_moving = true
	tween.tween_property(self, "position", _position, duration)
	await tween.finished
	is_moving = false

func set_dest(_dest: int) -> void:
	dest = _dest
	$Dest.text = str(_dest)

func remove(is_happy: bool) -> Signal:
	patience_tween.stop()
	for timer in face_timers:
		var connections = timer.timeout.get_connections()
		timer.timeout.disconnect(connections[0].callable)

	var result_scene = happy_result if is_happy else angry_result
	var result = result_scene.instantiate()
	var new_scale = result.scale.x * 2
	var duration = patience_ended_tween_duration

	if is_happy:
		$Face.play("happy")
	$Dest.hide()
	add_child(result)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, duration)
	for type in ["x", "y"]:
		tween.tween_property(result, "scale:" + type, new_scale, duration)

	return tween.finished

func _debug_test_result(is_happy: bool) -> void:
	await get_tree().create_timer(1).timeout
	remove(is_happy)