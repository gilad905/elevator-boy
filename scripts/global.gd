extends Node

@export var person_radius: int = 15
@export var person_spacing: int = 7
@export var person_move_speed: int = 120
@export var person_patience_sec: int = 30
@export var person_result_sec: float = 1.0

@export var angry_money_loss: int = 10
@export var money_by_happy_count: Array[int] = [0, 1, 10, 20, 40]

@export var one_floor_duration_sec: float = 1.0
@export var door_open_speed: int = 2

@export var win_on_amount: int = 150
@export var lose_on_angries: int = 10

@export var person_enter_max_sec: float = 5.0
@export var person_enter_min_sec: float = 1.5
@export var span_timer_decrease_sec: float = 0.2

@export var elevator_check_interval_sec: float = 0.5
@export var speed_span_max_sec: float = 45.0
@export var speed_span_min_sec: float = 5.0
@export var speed_span_level_decrease_sec: float = 5.0

var current_level: int = 1
var floor_count: int

func _ready() -> void:
	floor_count = get_node("/root/Main/Floors").get_child_count()

func _print(msg: String) -> void:
	var time = Time.get_time_string_from_system()
	print(time + " " + msg)