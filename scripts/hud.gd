extends Node2D

signal debt_reached()

@export var lose_on_debt: int

func _ready() -> void:
	$TimeScale.text = ""

func increment_money(go_up: bool) -> void:
	var shift = 1 if go_up else -1
	var new_amount = int($Money.text) + shift
	var color = Color.GREEN if new_amount >= 0 else Color.RED
	$Money.text = str(new_amount)
	$Money.add_theme_color_override("font_color", color)
	if new_amount == lose_on_debt:
		debt_reached.emit()
