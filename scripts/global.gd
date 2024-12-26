extends Node

@export var person_radius: int = 10
@export var person_spacing: int = 5
@export var person_move_speed: int = 120
@export var person_patience_sec: int = 30

@export var one_floor_duration_sec: float = 1.0
@export var door_open_speed: int = 2

@export var angry_money_loss: int = -10
@export var lose_on_debt: int = -10

@export var person_enter_max_sec: float = 5.0
@export var person_enter_min_sec: float = 1.5
@export var level_timer_decrease_sec: float = 0.2

@export var elevator_check_interval_sec: float = 0.5
@export var level_up_interval_sec: float = 45.0

var floor_count: int

func _ready() -> void:
	floor_count = get_node("/root/Main/Floors").get_child_count()
