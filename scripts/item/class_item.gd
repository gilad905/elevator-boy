class_name Item extends TextureRect

enum Type {Life}
const scene_path = "res://scenes/items/item_%s.tscn"
static var scenes = Funcs.get_scenes_by_type(scene_path, Type)

var type: Type

static func create(_type: Type) -> TextureRect:
	var item = scenes[_type].instantiate()
	item.type = _type
	return item

func activate() -> void:
	pass
