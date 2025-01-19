class_name Person extends Npc

var dest: int = -1

func _init() -> void:
	if type == Npc.Type.Unset:
		type = Npc.Type.Person
	super()

func _ready() -> void:
	to_animate = $Face
	$AngryResult/Amount.text = "-%s" % Global.angry_money_loss
	super()
	# if Global.debugging:
	# 	await get_tree().create_timer(2).timeout
	# 	remove(Npc.RemovalType.Fall)
	# 	show_result(false)

func _to_string() -> String:
	return "%s (%s)" % [get_instance_id(), dest]

func set_dest(_dest: int) -> void:
	dest = _dest
	$Dest.text = str(_dest)

func show_result(is_happy: bool) -> Signal:
	$Dest.hide()
	var tween = create_tween()
	if is_happy:
		$Face.play("happy")
	else:
		$Face.play("angry")
		$AngryResult.show()
		tween.set_parallel()
		NPCs.add_result_tweener(tween, $AngryResult)
	return tween.finished