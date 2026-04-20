class_name State

const path: String = "user://state._save_file"

static var _default = {
	current_level = 1,
	# current_level = 5 if Env.is_dev else 1,
	closet = [Item.Type.Life, Item.Type.Life],
	angry_count = 0,
}

static var current_level: int = _default.current_level
static var closet: Array = _default.closet.duplicate()
static var angry_count: int = 0

# reset on every run, not saved
static var on_welcome_screen: bool = true

static func _static_init() -> void:
	if Env.is_dev:
		print("DEV - adding broom to closet")
		_default.closet = [Item.Type.Life, Item.Type.Broom, Item.Type.Life]
		closet = _default.closet.duplicate()
	_load()

static func _load() -> void:
	var state = _load_file()
	if state.has("current_level"):
		current_level = state.current_level
	if state.has("closet"):
		closet = state.closet
	if state.has("angry_count"):
		angry_count = state.angry_count

static func save() -> void:
	var state = {
		current_level = current_level,
		closet = closet,
		angry_count = angry_count,
	}
	_save_file(state)

static func reset() -> void:
	current_level = _default.current_level
	closet = _default.closet.duplicate()
	angry_count = _default.angry_count
	save()

static func _load_file() -> Dictionary:
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

static func _save_file(state: Dictionary) -> void:
	var text = JSON.stringify(state)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(text)
	file.close()
