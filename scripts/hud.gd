extends Node2D

signal debt_reached()

func increment_money(go_up: bool) -> void:
	var shift = 1 if go_up else Global.angry_money_loss
	var new_amount = int($Money.text) + shift
	var color = Color.GREEN if new_amount >= 0 else Color.RED
	$Money.text = str(new_amount)
	$Money.add_theme_color_override("font_color", color)
	if new_amount == Global.lose_on_debt:
		debt_reached.emit()
