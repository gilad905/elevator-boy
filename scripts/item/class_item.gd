class_name Item extends Button

enum Type {Life, Broom}
const scene_path = "res://scenes/items/item_%s.tscn"
static var scenes = Funcs.get_scenes_by_type(scene_path, Type)

var type: Type

static func create(_type: Type) -> Button:
	var item = scenes[_type].instantiate()
	item.type = _type
	return item

func activate() -> void:
	remove()

func remove() -> void:
	Nodes.Closet.remove_item(self)

func _on_pressed() -> void:
	pass # Replace with function body.
