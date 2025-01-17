class_name Person extends Npc

var dest: int = -1

func _init() -> void:
	type = Npc.Type.Person
	super()

func _ready() -> void:
	to_animate = $Face
	$AngryResult/Amount.text = "-%s" % Global.angry_money_loss
	super()

func _to_string() -> String:
	return "%s (%s)" % [get_instance_id(), dest]

func set_dest(_dest: int) -> void:
	dest = _dest
	$Dest.text = str(_dest)

func end_with_result(is_happy: bool) -> Signal:
	$Dest.hide()
	var tween = fade_out()

	if is_happy:
		$Face.play("happy")
	else:
		$Face.play("angry")
		$AngryResult.show()
		tween.set_parallel()
		NPCs.add_result_tweener(tween, $AngryResult)

	return tween.finished

func remove_with_result(is_happy: bool) -> Signal:
	init_end()
	var ended = end_with_result(is_happy)
	ended.connect(_remove_node)
	return ended

func _debug_test_result(is_happy: bool) -> void:
	await get_tree().create_timer(1).timeout
	remove_with_result(is_happy)
