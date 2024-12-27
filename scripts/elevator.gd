extends Room

var floors: Node
var current_floor_num: int
var floor_height: int
var is_moving: bool = false
var persons_offset: Vector2
var inner_size: Vector2

func _ready() -> void:
	self.person_limit = 4
	current_floor_num = Global.floor_count
	var floor_1 = get_node("/root/Main/Floors/Floor_1")
	var floor_2 = get_node("/root/Main/Floors/Floor_2")
	floors = get_node("/root/Main/Floors")
	floors.set_floor_pressed(current_floor_num)
	floor_height = floor_1.position.y - floor_2.position.y
	inner_size.x = $Frame.points[0].x - $Frame.points[1].x - $Frame.width
	inner_size.y = $Frame.points[3].y - $Frame.points[0].y - $Frame.width
	persons_offset = Vector2.ONE * ($Frame.width / 2 - Global.person_radius)

func go_to_floor(floor_num: int) -> void:
	if is_moving:
		return
	if floor_num == current_floor_num:
		$Door.toggle_state()
		return

	assert(is_floor_in_bounds(floor_num), "Target floor is out of bounds")

	is_moving = true

	floors.set_floor_pressed(floor_num)
	if $Door.current_state != $Door.State.closed:
		$Door.set_state($Door.State.closing)
		await $Door.has_closed

	var floor_delta = current_floor_num - floor_num
	var target_y = position.y + floor_delta * floor_height
	var duration = abs(floor_delta) * Global.one_floor_duration_sec
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", target_y, duration)
	await tween.finished
	$Door.set_state($Door.State.opening)
	is_moving = false

	current_floor_num = floor_num

func move_one_floor(go_up: bool) -> void:
	var target_floor: int = current_floor_num + (1 if go_up else -1)
	if is_floor_in_bounds(target_floor):
		go_to_floor(target_floor)

func get_person_position(i: int) -> Vector2:
	var _position = Vector2.ZERO
	_position.x += 1 if i % 2 else 0
	_position.y += 1 if i > 1 else 0
	_position = persons_offset + inner_size / 4 * (_position * 2 + Vector2.ONE)
	return _position

func remove_persons_in_dest() -> void:
	var reached_tween: Tween = null
	for person in $Persons.get_children():
		if person.dest == current_floor_num:
			var is_happy = not person.is_patience_ended
			reached_tween = person.show_patience_ended(is_happy)
			get_node("/root/Main/HUD").increment_money(is_happy)
	if reached_tween:
		await reached_tween.finished
		update_person_positions()

func is_floor_in_bounds(floor_num: int) -> bool:
	return floor_num >= 1 and floor_num <= Global.floor_count

func _on_door_toggle_pressed() -> void:
	if not is_moving:
		$Door.toggle_state()
