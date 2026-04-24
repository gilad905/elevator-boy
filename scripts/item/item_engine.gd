extends Item

func _on_pressed() -> void:
	# needs to call activate() for super.activate()
	activate()

func activate() -> void:
	Nodes.Elevator.activate_engine()
	super ()