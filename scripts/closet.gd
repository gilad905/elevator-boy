extends TextureRect

const ITEM_LIMIT: int = 7
var items: Control

func _ready() -> void:
	items = $MarginContainer/Items
	for item in items.get_children():
		item.queue_free()
		items.remove_child(item)
	
	# if Env.is_dev:
	# 	print("DEV - testing item rolls")
	# 	for i in range(30):
	# 		await get_tree().create_timer(0.5).timeout
	# 		add_random_item()

func load_from_state() -> void:
	for item_type in State.closet:
		_add_item(item_type)
	_update_item_positions(false)

func find_item(type: Item.Type) -> Item:
	var items_of_type = _get_items_of_type(type)
	if items_of_type.size() > 0:
		return items_of_type[0]
	return null

func _get_items_of_type(type: Item.Type) -> Array:
	return items.get_children().filter(func(item): return item.type == type)

func _roll_random_item() -> Item.Type:
	var life_count = _get_items_of_type(Item.Type.Life).size()
	if life_count < Settings.life_min_amount_for_roll:
		return Item.Type.Life

	var weighted_types: Array[Item.Type] = []
	for type in Item.Type.values():
		var roll_weight: int = Settings.item_meta[type].roll_weight
		var type_weights = range(roll_weight).map(func(_n): return type)
		weighted_types.append_array(type_weights)
	var type = weighted_types.pick_random()
	# print("rolled item: ", Item.Type.keys()[type])
	return type

func add_random_item() -> void:
	if not has_room():
		var oldest_item = items.get_child(0)
		remove_item(oldest_item)
		# items.remove_child(oldest_item)
		# oldest_item.queue_free()

	var type = _roll_random_item()
	var item = _add_item(type)
	
	if "guide" in item.meta and \
	not State.viewed_guides.has(item.meta.guide):
		State.viewed_guides.append(item.meta.guide)
		var modal = Nodes.Main.get_node("Foreground/Modal")
		await modal.show_modal(item.meta.guide)

	_update_state()
	await _update_item_positions(true)

func remove_item(item: Item) -> void:
	items.remove_child(item)
	item.queue_free()
	_update_state()
	await _update_item_positions(true)

func has_room() -> bool:
	return items.get_child_count() < ITEM_LIMIT

func _add_item(item_type: Item.Type) -> Item:
	var item = Item.create(item_type)
	var entrance_x = self.size.x + item.size.x
	item.position.x = entrance_x
	items.add_child(item)
	return item

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
			Funcs.fly_node_to(item, end_position, Settings.item_speed)
		else:
			item.position = end_position
