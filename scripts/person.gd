extends Node2D

signal patience_ended(person: Node2D)

const angry_result = preload("res://scenes/angry_result.tscn")
const zero_angle: float = PI * -0.5
const full_angle: float = PI * 1.5

static var radius = Global.person_radius
static var circle_center = Vector2.ONE * radius

var dest: int = -1
var is_patience_ended: bool = false
var patience_tween: Tween
var movement_tween: Tween
var current_angle: float = 0
var face_timers = []

func _ready() -> void:
	start_patience_tween()
	# _debug_test_result(true)

func _draw() -> void:
	draw_circle(circle_center, radius, Color.WHITE, false, 2)
	draw_arc(circle_center, radius, zero_angle, current_angle, 64, Color.RED, 2)

func _to_string() -> String:
	return "%s (%s)" % [get_instance_id(), dest]

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
	var timer = get_tree().create_timer(sec, false)
	timer.timeout.connect($Face.play.bind(state))
	face_timers.append(timer)

func redraw_patience(angle: float) -> void:
	current_angle = angle
	queue_redraw()

func move_to(_position):
	var duration = position.distance_to(_position) / Global.person_move_speed
	movement_tween = create_tween()
	movement_tween.tween_property(self, "position", _position, duration)
	await movement_tween.finished

func set_dest(_dest: int) -> void:
	dest = _dest
	$Dest.text = str(_dest)

func remove(is_happy: bool) -> Signal:
	patience_tween.stop()
	for timer in face_timers:
		var connections = timer.timeout.get_connections()
		timer.timeout.disconnect(connections[0].callable)

	$Dest.hide()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, Global.person_result_sec)

	if is_happy:
		$Face.play("happy")
	else:
		var result = angry_result.instantiate()
		result.get_node("Amount").text = "-%s" % Global.angry_money_loss
		Nodes.persons.add_result_tweener(tween, result)
		add_child(result)

	return tween.finished

func is_moving() -> bool:
	return movement_tween and movement_tween.is_running()

func _debug_test_result(is_happy: bool) -> void:
	await get_tree().create_timer(1).timeout
	remove(is_happy)
