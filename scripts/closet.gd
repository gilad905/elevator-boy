extends Control

const item_limit: int = 5

func _ready() -> void:
	for item_type in Global.closet:
		var item = Item.create(item_type)
		$Items.add_child(item)

# func has_item(type: Item.Type) -> bool:
# 	return $Items.has_node(Item.Type.find_key(type))

func find_item(type: Item.Type) -> Item:
	for item in $Items.get_children():
		if item.type == type:
			return item
	return null

func remove_item(item: Item) -> void:
	$Items.remove_child(item)
	var i = Global.closet.find(item.type)
	Global.closet.remove_at(i)
	item.queue_free()

func add_random_item() -> Item:
	var type = Item.Type.values().pick_random()
	var item = Item.create(type)
	$Items.add_child(item)
	return item
