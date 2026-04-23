class_name Person extends Npc

var dest: int = -1
var meta: Dictionary

func _init() -> void:
	if type == Npc.Type.Unset:
		type = Npc.Type.Person
	super ()

func _ready() -> void:
	to_animate = $Face
	meta = Settings.npc_meta[type]
	if meta.has("money_loss") and meta.money_loss > 0:
		$AngryFloater/Amount.text = "-%s" % meta.money_loss
	super ()
	# if Env.is_dev:
	# 	print("DEV - making person fall")
	# 	await get_tree().create_timer(2).timeout
	# 	remove(Npc.RemovalType.Fall)
	# 	show_result(false)

func _to_string() -> String:
	return "%s (%s)" % [get_instance_id(), dest]

func set_dest(_dest: int) -> void:
	dest = _dest
	$Dest.text = str(_dest)

func show_result(is_happy: bool) -> void:
	$Dest.hide()
	if is_happy:
		$Face.play("happy")
	else:
		$Face.play("angry")
		var sound_name = "Grunt" if not meta.has("angry_sound") else meta.angry_sound
		Nodes.AudioManager.play_sound(sound_name)
		if meta.has("money_loss") and meta.money_loss > 0:
			$AngryFloater.show()
			NPCs.tween_floater($AngryFloater)