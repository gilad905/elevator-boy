class_name State

const path: String = "user://state._save_file"

static var _default = {
	current_level = 1,
	# current_level = 5 if Env.is_dev else 1,
	closet = [Item.Type.Life, Item.Type.Life],
	angry_count = 0,
	viewed_guides = [],
}

## game progress ##
static var current_level: int = _default.current_level
static var closet: Array = _default.closet.duplicate()
static var angry_count: int = 0

## interface ##
static var viewed_guides: Array = _default.viewed_guides.duplicate()
# not persistent
static var on_welcome_screen: bool = true
# does not reset
static var sounds_on: bool = true
static var music_on: bool = true

static func _static_init() -> void:
	if Env.is_dev:
		print("DEV - adding broom to closet")
		_default.closet = [Item.Type.Life, Item.Type.Broom, Item.Type.Life]
		closet = _default.closet.duplicate()
	_load_state_file()

static func _load_state_file() -> void:
	var file_state = _get_state_from_file()
	reset()
	if file_state.has("current_level"):
		current_level = file_state.current_level
	if file_state.has("closet"):
		closet = file_state.closet
	if file_state.has("angry_count"):
		angry_count = file_state.angry_count
	if file_state.has("viewed_guides"):
		viewed_guides = file_state.viewed_guides
	if file_state.has("sounds_on"):
		sounds_on = file_state.sounds_on
	if file_state.has("music_on"):
		music_on = file_state.music_on

static func save() -> void:
	var state = {
		current_level = current_level,
		closet = closet,
		angry_count = angry_count,
		viewed_guides = viewed_guides,
		sounds_on = sounds_on,
		music_on = music_on,
	}
	_save_file(state)

static func reset() -> void:
	current_level = _default.current_level
	closet = _default.closet.duplicate()
	angry_count = _default.angry_count
	viewed_guides = _default.viewed_guides.duplicate()

static func _get_state_from_file() -> Dictionary:
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
