extends ColorRect

const item_limit: int = 7
var items: Control

func _ready() -> void:
	items = $MarginContainer/Items
	for item_type in State.closet:
		var item = Item.create(item_type)
		items.add_child(item)

func find_item(type: Item.Type) -> Item:
	for item in items.get_children():
		if item.type == type:
			return item
	return null

func remove_item(item: Item) -> void:
	items.remove_child(item)
	item.queue_free()
	_update_global_closet()

func has_room() -> bool:
	return items.get_child_count() < item_limit

func add_random_item() -> Item:
	assert(has_room(), name + " is full")
	var type = Item.Type.values().pick_random()
	var item = Item.create(type)
	items.add_child(item)
	_update_global_closet()
	return item

func _update_global_closet() -> void:
	State.closet.clear()
	for item in items.get_children():
		State.closet.append(item.type)
