extends Area2D

var dest: int = -1
var circle_center = Vector2(Global.person_radius, Global.person_radius)

func _draw() -> void:
	draw_circle(circle_center, Global.person_radius, Color.WHITE, false)

func set_dest(_dest: int) -> void:
	dest = _dest
	var label = get_node("./Label")
	label.text = str(_dest)
