extends Label

@export var border_color: Color

func _draw():
	draw_rect(Rect2(0, 0, size.x, size.y), border_color, false)
