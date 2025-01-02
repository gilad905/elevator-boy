extends Node2D

signal money_reached
signal angries_reached

const glow_outline: int = 18
const glow_shadow: int = 40
var start_outline: float

func _ready() -> void:
	start_outline = $Money/Amount.get_theme_constant("outline_size")
	$Money/Amount.text = "0"
	$Angries/Amount.text = "0"
	$Level/Value.text = str(Global.current_level)
	$Money/Total.text = "/" + str(Global.win_on_amount)
	$Angries/Total.text = "/" + str(Global.lose_on_angries)
	# _debug_test_increments()
	
func increment_money(amount: int) -> void:
	var new_amount = _increment_counter($Money, amount)
	if new_amount >= Global.win_on_amount:
		money_reached.emit()

func increment_angries(amount: int) -> void:
	var new_amount = _increment_counter($Angries, amount)
	if new_amount >= Global.lose_on_angries:
		angries_reached.emit()

func _increment_counter(field: Node2D, amount: int) -> int:
	var counter = field.get_node("Amount")
	var new_amount = clamp(int(counter.text) + amount, -999, 999)
	counter.text = str(new_amount)
	
	var tween = counter.create_tween()
	var glow_func = _update_label_glow.bind(counter)
	tween.tween_method(glow_func, 0.0, 1.0, 0.3)
	tween.tween_method(glow_func, 1.0, 0.0, 0.3)

	return new_amount

func _update_label_glow(value: float, counter: Label) -> void:
	var outline = start_outline + int(value * (glow_outline - start_outline))
	var shadow = int(value * glow_shadow)
	# print("%s %s" % [outline, shadow])
	counter.add_theme_constant_override("outline_size", outline)
	counter.add_theme_constant_override("shadow_outline_size", shadow)

func _debug_test_increments() -> void:
	# put at _ready()
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.timeout.connect(increment_money.bind(1))
	timer.timeout.connect(increment_angries.bind(1))
	timer.start()
