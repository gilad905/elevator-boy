extends Npc

func _init() -> void:
	type = Npc.Type.Bomb
	super()

func _ready() -> void:
	to_animate = $Face/Red
	super()

func _draw() -> void:
	if not _showing_end:
		super()

func explode() -> Signal:
	init_end()
	patience_tween.stop()
	queue_redraw() # removes the patience circle
	$Face.hide()
	$Explode.show()
	$Explode.play()
	var ended = $Explode.animation_finished
	ended.connect(_remove_node)
	return ended