extends Npc

const angry_result = preload("res://scenes/angry_result.tscn")

var dest: int = -1
var face_timers = []

func _ready() -> void:
	npc_type = Npc.Type.Person
	patience_sec = Global.person_patience_sec
	super()

func _to_string() -> String:
	return "%s (%s)" % [get_instance_id(), dest]

func init(_dest: int) -> void:
	dest = _dest
	$Dest.text = str(_dest)

func start_patience_tween() -> void:
	super()
	add_face_timer(50, "angry_1")
	add_face_timer(75, "angry_2")
	await patience_tween.finished
	$Face.play("angry_3")

func add_face_timer(percent: int, state: String) -> void:
	var sec = Global.person_patience_sec * percent / 100.0
	var timer = get_tree().create_timer(sec, false)
	timer.timeout.connect($Face.play.bind(state))
	face_timers.append(timer)

func end_with_result(is_happy: bool) -> Signal:
	remove()
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
		$Face.play("angry_3")
		var result = angry_result.instantiate()
		result.get_node("Amount").text = "-%s" % Global.angry_money_loss
		NPCs.add_result_tweener(tween, result)
		add_child(result)

	return tween.finished

func _debug_test_result(is_happy: bool) -> void:
	await get_tree().create_timer(1).timeout
	end_with_result(is_happy)
