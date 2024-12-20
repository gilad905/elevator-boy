extends Node2D

func _ready() -> void:
	$Persons.add_person()
	# pass

func _process(_delta: float) -> void:
	pass

func _on_persons_timer_timeout() -> void:
	pass
	# $Persons.add_person()
