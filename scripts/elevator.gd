extends Line2D

@export var one_floor_duration_sec: int

var current_floor: int = Global.floor_count
var floor_height: int
var is_moving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var floor_shape: CollisionShape2D = get_node("/root/Main/Floors/Floor_1/CollisionShape2D");
	floor_height = floor_shape.shape.size.y

func go_to_floor(floor_num: int) -> void:
	if is_moving:
		return

	var in_bounds = floor_num >= 1 or floor_num <= Global.floor_count
	assert(in_bounds, "Target floor is out of bounds")

	var floor_delta = current_floor - floor_num
	current_floor = floor_num
	var target_y = position.y + floor_delta * floor_height
	var duration = abs(floor_delta) * one_floor_duration_sec
	var tween: Tween = create_tween()
	is_moving = true
	tween.tween_property(self, "position:y", target_y, duration)
	await tween.finished
	is_moving = false

func move_one_floor(go_up: bool) -> void:
	var target_floor: int = current_floor + (1 if go_up else -1)
	go_to_floor(target_floor)
