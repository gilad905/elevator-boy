extends Room

var floors: Node
var current_floor_num: int
var floor_height: int
var is_moving: bool = false
var persons_offset: Vector2
var inner_size: Vector2

func _ready() -> void:
	super()
	self.person_limit = 4
	current_floor_num = Global.floor_count
	floors = get_node("/root/Main/Floors")
	floors.set_floor_pressed(current_floor_num)
	var floor_1 = floors.get_node("Floor_1")
	var floor_2 = floors.get_node("Floor_2")
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

	assert(is_floor_in_bounds(floor_num), "floor out of bounds")

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
	var removed_signal: Signal
	var happy_count: int = 0
	var angry_count: int = 0
	for person in $Persons.get_children():
		if person.dest == current_floor_num:
			var is_happy = not person.is_patience_ended
			if is_happy:
				happy_count += 1
			else:
				angry_count += 1
			removed_signal = remove_person(person, is_happy)
	update_hud(happy_count, angry_count)
	if removed_signal:
		await removed_signal
		# Global._print("updating positon after removals")
		update_person_positions()

func update_hud(happy_count: int, angry_count: int) -> void:
	var money_shift = 0
	if happy_count > 0:
		var happy_money = Global.money_by_happy_count[happy_count]
		show_happy_result(happy_money)
		money_shift += happy_money
	if angry_count > 0:
		var angry_money = Global.angry_money_loss * angry_count
		money_shift -= angry_money
		hud.increment_angries(angry_count)
	if money_shift != 0:
		hud.increment_money(money_shift)

func is_floor_in_bounds(floor_num: int) -> bool:
	return floor_num >= 1 and floor_num <= Global.floor_count

func show_happy_result(money: int) -> void:
	$HappyResult/Amount.text = "x" + str(money)
	$HappyResult.show()
	var tween = create_tween()
	tween.set_parallel(true)
	get_node("/root/Main/Persons").add_result_tweener(tween, $HappyResult)
	await tween.finished
	$HappyResult.hide()

func add_person(person) -> void:
	# Global._print("adding %s of %s" % [person, $Persons.get_child_count()])
	assert(has_room(), name + " is full")
	if person.get_parent():
		person.reparent($Persons)
	else:
		$Persons.add_child(person)
	super(person)

func _on_door_toggle_pressed() -> void:
	if not is_moving:
		$Door.toggle_state()
