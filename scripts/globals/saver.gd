const path: String = "user://state.save"

static func get_state() -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var text = FileAccess.get_file_as_string(path)
	var parser = JSON.new()
	var parse_result = parser.parse(text)
	if not parse_result == OK:
		var err_msg = parser.get_error_message()
		var err_line = parser.get_error_line()
		var msg = "JSON Parse Error: %s at line %s" % [err_msg, err_line]
		assert(false, msg)

	var state = parser.data
	return state

static func save_state(state: Dictionary) -> void:
	var text = JSON.stringify(state)
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_string(text)