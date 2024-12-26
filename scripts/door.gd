extends Line2D

enum State {closed, opening, open, closing}
var current_state: State = State.closed

signal has_closed
signal state_changed(state: State)

func _process(delta: float) -> void:
	if [State.opening, State.closing].has(current_state):
		var is_opening = current_state == State.opening
		var target_y = 0 if is_opening else 1
		if is_equal_approx(scale.y, target_y):
			scale.y = target_y
			var target_state = State.open if is_opening else State.closed
			current_state = target_state
			state_changed.emit(target_state)
			if target_state == State.closed:
				has_closed.emit()

		else:
			var delta_factor = -1 if is_opening else 1
			var delta_y = delta * delta_factor * Global.door_open_speed
			scale.y = clamp(scale.y + delta_y, 0, 1)

func toggle_state() -> void:
	var is_opening = [State.open, State.opening].has(current_state)
	var target_state = State.closing if is_opening else State.opening
	set_state(target_state)

func set_state(state: State) -> void:
	var is_opening = [State.open, State.opening].has(state)
	var target_state = State.opening if is_opening else State.closing
	current_state = target_state
	state_changed.emit(target_state)
