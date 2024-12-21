extends Line2D

@export var move_speed: float

enum State {closed, opening, open, closing}
var current_state: State = State.closed

signal door_opened

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("door_toggle"):
		var is_opening = [State.open, State.opening].has(current_state)
		current_state = State.closing if is_opening else State.opening

	if [State.opening, State.closing].has(current_state):
		var is_opening = current_state == State.opening
		var target_y = 0 if is_opening else 1
		if is_equal_approx(scale.y, target_y):
			scale.y = target_y
			var target_state = State.open if is_opening else State.closed
			current_state = target_state
			var state_desc = "open" if target_state == State.open else "closed"
			print("Door is now " + state_desc)
			if current_state == State.open:
				door_opened.emit()
		else:
			var delta_factor = -1 if is_opening else 1
			var delta_y = delta * delta_factor * move_speed
			scale.y = clamp(scale.y + delta_y, 0, 1)