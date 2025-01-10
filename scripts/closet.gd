extends Control

func _ready() -> void:
	for i in 2:
		var life = Item.create("life")
		$Items.add_child(life)