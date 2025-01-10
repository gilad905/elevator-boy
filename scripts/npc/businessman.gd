extends Person

func _draw() -> void:
	super()
	draw_line(Vector2.ZERO, Vector2.ONE * 10, Color.BLACK, 10)