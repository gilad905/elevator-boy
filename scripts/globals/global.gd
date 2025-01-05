extends Node

@export var npc_spacing: int = 7
@export var npc_speed: int = 200
@export var patience_radius: int = 15
@export var patience_sec: int = 30
@export var person_result_sec: float = 1.0

@export var angry_money_loss: int = 10
@export var money_by_happy_count: Array[int] = [0, 1, 5, 10, 20]

@export var half_floor_sec: float = 0.4
@export var door_speed: int = 3

@export var win_on_amount: int = 100
@export var lose_on_angries: int = 5

@export var person_enter_max_sec: float = 5.0
@export var person_enter_min_sec: float = 1.5
@export var span_timer_decrease_sec: float = 0.2

@export var bomb_one_in = 0
# @export var bomb_one_in = 1

@export var elevator_check_interval_sec: float = 0.5
@export var speed_span_max_sec: float = 45.0
@export var speed_span_min_sec: float = 5.0
@export var speed_span_level_decrease_sec: float = 5.0

enum NpcType {person, bomb}

var current_level: int = 1
var floor_count: int

func _ready() -> void:
	if Nodes.floors:
		floor_count = Nodes.floors.get_child_count()

func _print(msg: String) -> void:
	var time = Time.get_time_string_from_system()
	print(time + " " + msg)
