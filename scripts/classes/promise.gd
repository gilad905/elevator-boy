# class_name Promise

# signal completed()

# enum Mode {ANY, ALL}
# var mode: Mode
# var emitted_count: int = 0

# static func await_all(signals: Array) -> Signal:
# 	var emit_count = {count = 0} # using a dictionary to pass by reference
# 	var _on_emit: Callable = func():
# 		print("_on_emit")
# 		emit_count.count += 1
# 		print(emit_count.count)
# 		if emit_count.count == signals.size():
# 			all_emitted.emit()
# 	for _signal in signals:
# 		_signal.connect(_on_emit)
# 	return all_emitted

# func _init(signals: Array, mode: int) -> void:
# 	for s in signals:
# 		s.connect(self, _on_signal, [s])

# func _on_signal(_signal: Callable) -> void:
# 	_signals[_signal] = true
# 	_check_completion()

# func _check_completion():
# 	if _completed:
# 		return

# 	if mode == Mode.ANY:
# 		_check_any_completion()
# 	elif mode == Mode.ALL:
# 		_check_all_completion()

# func _check_any_completion() -> void:
# 	for _signal in _signals:
# 		if _signals[_signal].has_emitted:
# 			completed.emit(_signals[_signal].data)
# 			return

# func _check_all_completion() -> void:
# 	for _signal in _signals:
# 		if not _signals[_signal].has_emitted:
# 			return