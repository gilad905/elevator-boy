@tool

extends Polygon2D

@export var line_color: Color
@export var line_width: float

func _draw() -> void:
	var closed_polygon = self.polygon
	closed_polygon.append(self.polygon[0])
	draw_polyline(closed_polygon, line_color, line_width)
