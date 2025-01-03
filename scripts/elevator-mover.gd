extends Node

var current_y: float:
	get: return elevator.position.y
# var current_floor_num: int:
# 	get: return get_parent().current_floor_num
var half_floor: int
var tween: Tween

func _ready() -> void:
	var floor_1 = Nodes.floors.get_floor(1)
	var floor_2 = Nodes.floors.get_floor(2)
	half_floor = (floor_1.position.y - floor_2.position.y) / 2

func move_to(floor_num: int) -> void:
	if (tween):
		await tween.finished

	var _floor = Nodes.floors.get_floor(floor_num)
	var target_y = _floor.position.y
	var delta = current_y - target_y
	var direction = delta / abs(delta)
	var target_y = position.y + floor_delta * floor_height
	var duration = abs(floor_delta) * Global.half_floor_duration_sec

	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", target_y, duration)
	await tween.finished

	acceleration = 1 if target_y > current_y else -1
	await reached_floor