class_name Item extends TextureRect

const types: Array = ["life"]
const scene_path = "res://scenes/items/item_%s.tscn"
static var scenes = {}

static func _static_init() -> void:
	for type in types:
		scenes[type] = load(scene_path % type)

static func create(type: String) -> TextureRect:
	var item = scenes[type].instantiate()
	return item
