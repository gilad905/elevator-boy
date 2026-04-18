class_name Env

# auto-detects dev environment; override with ELEVATOR_ENV=dev or ELEVATOR_ENV=prod
static func _resolve_is_dev() -> bool:
	var env: String = OS.get_environment("ELEVATOR_ENV").to_lower()
	if env == "dev":
		return true
	if env == "prod":
		return false
	return OS.has_feature("editor") or OS.is_debug_build()

# cannot be in settings.gd because of cyclic dependency
# static var is_dev: bool = false
static var is_dev: bool = _resolve_is_dev()
static var version: String = "1"