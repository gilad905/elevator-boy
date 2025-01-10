class_name Item extends TextureRect

enum Type {Life}
const scene_path = "res://scenes/items/item_%s.tscn"
static var scenes = {}

var type: Type

static func _static_init() -> void:
	for type_name in Type:
		var _type = Type[type_name]
		scenes[_type] = load(scene_path % type_name.to_lower())

static func create(_type: Type) -> TextureRect:
	var item = scenes[_type].instantiate()
	item.type = _type
	return item

func activate() -> void:
	pass
