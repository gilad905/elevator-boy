extends Control

const item_limit: int = 7

func _ready() -> void:
	for item_type in Settings.closet:
		var item = Item.create(item_type)
		$Items.add_child(item)

func find_item(type: Item.Type) -> Item:
	for item in $Items.get_children():
		if item.type == type:
			return item
	return null

func remove_item(item: Item) -> void:
	$Items.remove_child(item)
	item.queue_free()
	_update_global_closet()

func has_room() -> bool:
	return $Items.get_child_count() < item_limit

func add_random_item() -> Item:
	assert(has_room(), name + " is full")
	var type = Item.Type.values().pick_random()
	var item = Item.create(type)
	$Items.add_child(item)
	_update_global_closet()
	return item

func _update_global_closet() -> void:
	Settings.closet.clear()
	for item in $Items.get_children():
		Settings.closet.append(item.type)
