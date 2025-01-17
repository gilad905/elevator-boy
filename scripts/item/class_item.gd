class_name Item extends TextureRect

enum Type {Life, Broom}
const scene_path = "res://scenes/items/item_%s.tscn"
static var scenes = Funcs.get_scenes_by_type(scene_path, Type)

var type: Type

static func create(_type: Type) -> TextureRect:
	var item = scenes[_type].instantiate()
	item.type = _type
	return item

func activate() -> void:
	remove()

func remove() -> void:
	Nodes.Closet.remove_item(self)

func _on_click() -> void:
	pass
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_click()
