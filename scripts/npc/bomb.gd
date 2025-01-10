extends Npc

func _ready() -> void:
	type = Npc.Type.Bomb
	super()

func _draw() -> void:
	if not being_removed:
		super()

func explode() -> Signal:
	remove()
	queue_redraw() # removes the patience circle
	$Face.hide()
	$Explode.show()
	$Explode.play()
	return $Explode.animation_finished
