extends Line2D

@export var one_floor_duration_sec: int

var current_floor_num: int
var floor_height: int
var is_moving: bool = false

func _ready() -> void:
	current_floor_num = Global.floor_count
	var floor_shape: CollisionShape2D = get_node("/root/Main/Floors/Floor_1/CollisionShape2D")
	floor_height = floor_shape.shape.size.y

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("door_toggle"):
		if not is_moving:
			$Door.toggle_state()

func go_to_floor(floor_num: int) -> void:
	if is_moving:
		return

	assert(is_floor_in_bounds(floor_num), "Target floor is out of bounds")

	var floor_delta = current_floor_num - floor_num
	var target_y = position.y + floor_delta * floor_height
	var duration = abs(floor_delta) * one_floor_duration_sec
	var tween = create_tween()

	is_moving = true
	tween.tween_property(self, "position:y", target_y, duration)
	await tween.finished
	is_moving = false

	current_floor_num = floor_num

func move_one_floor(go_up: bool) -> void:
	var target_floor: int = current_floor_num + (1 if go_up else -1)
	if not is_floor_in_bounds(target_floor):
		return
	go_to_floor(target_floor)

func add_person(person):
	$Persons.add_child(person)
	var i = person.get_index()
	var _position = get_person_position(i)
	person.position = _position

func get_person_position(i: int) -> Vector2:
	var spacing = Global.person_spacing
	var radius = Global.person_radius
	var x = spacing + (spacing + radius * 2) * i
	return Vector2(x, 25)

func remove_persons_in_dest() -> void:
	for person in $Persons.get_children():
		if person.dest == current_floor_num:
			$Persons.remove_child(person)
			person.queue_free()

func is_floor_in_bounds(floor_num: int) -> bool:
	return floor_num >= 1 and floor_num <= Global.floor_count
