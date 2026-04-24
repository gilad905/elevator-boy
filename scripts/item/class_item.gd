class_name Item extends Button

enum Type {Life, Broom, Engine}
const scene_path = "res://scenes/items/item_%s.tscn"
static var scenes = Funcs.get_scenes_by_type(scene_path, Type)

var type: Type
var meta: Dictionary

static func create(_type: Type) -> Button:
	var item = scenes[_type].instantiate()
	item.type = _type
	item.meta = Settings.item_meta[_type]
	return item

func activate() -> void:
	# if Env.is_dev and type != Type.Life:
	# 	print("DEV - not removing ", Item.Type.keys()[type])
	# 	return
	remove()

func remove() -> void:
	Nodes.Closet.remove_item(self )

func _on_pressed() -> void:
	pass
