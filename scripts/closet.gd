extends TextureRect

const ITEM_LIMIT: int = 7
var items: Control

func _ready() -> void:
	items = $MarginContainer/Items
	for item in items.get_children():
		item.queue_free()

func load_from_state() -> void:
	for item_type in State.closet:
		# print("Loading item from state: ", item_type)
		_add_item(item_type)
	_update_state()
	_update_item_positions(false)

func find_item(type: Item.Type) -> Item:
	for item in items.get_children():
		if item.type == type:
			return item
	return null

func add_random_item() -> void:
	assert(has_room(), name + " is full")
	var type = Item.Type.values().pick_random()
	_add_item(type)
	_update_state()
	await _update_item_positions(true)

func remove_item(item: Item) -> void:
	items.remove_child(item)
	item.queue_free()
	_update_state()
	await _update_item_positions(true)

func has_room() -> bool:
	return items.get_child_count() < ITEM_LIMIT

func _add_item(item_type: Item.Type) -> void:
	var item = Item.create(item_type)
	var entrance_x = self.size.x + item.size.x
	item.position.x = entrance_x
	items.add_child(item)

func _update_state() -> void:
	State.closet.clear()
	for item in items.get_children():
		State.closet.append(item.type)

func _update_item_positions(fly: bool) -> void:
	var spacing = Settings.item_spacing + Settings.item_size
	for i in range(items.get_child_count()):
		var item = items.get_child(i)
		var x = spacing * i
		var end_position = Vector2(x, item.position.y)
		if fly:
			var tween = Funcs.fly_node_to(item, end_position, Settings.item_speed)
			await tween.finished
		else:
			item.position = end_position