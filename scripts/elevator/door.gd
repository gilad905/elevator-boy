extends Line2D

enum DoorState {closed, opening, open, closing}
var current_state: DoorState = DoorState.closed

signal has_closed
signal state_changed(state: State)

func _process(delta: float) -> void:
	if [DoorState.opening, DoorState.closing].has(current_state):
		var is_opening = current_state == DoorState.opening
		var target_y = 0 if is_opening else 1
		if is_equal_approx(scale.y, target_y):
			scale.y = target_y
			current_state = DoorState.open if is_opening else DoorState.closed
			state_changed.emit(current_state)
			# if current_state == DoorState.open:
			# 	Nodes.AudioManager.play_sound("Ding")
			if current_state == DoorState.closed:
				has_closed.emit()

		else:
			var direction = -1 if is_opening else 1
			var delta_y = delta * direction * Settings.door_speed
			scale.y = clamp(scale.y + delta_y, 0, 1)

func toggle_state() -> void:
	var is_opening = [DoorState.open, DoorState.opening].has(current_state)
	var target_state = DoorState.closing if is_opening else DoorState.opening
	set_state(target_state)

func set_state(state: DoorState) -> void:
	var is_opening = [DoorState.open, DoorState.opening].has(state)
	var target_state = DoorState.opening if is_opening else DoorState.closing
	current_state = target_state
	state_changed.emit(target_state)
