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
	remove()

	$Dest.hide()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate:a", 0, Global.person_result_sec)

	if is_happy:
		$Face.play("happy")
	else:
		$AngryResult.show()
		NPCs.add_result_tweener(tween, $AngryResult)

	return tween.finished

func _debug_test_result(is_happy: bool) -> void:
	await get_tree().create_timer(1).timeout
	end_with_result(is_happy)
