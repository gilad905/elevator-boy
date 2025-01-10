extends Node

const money_by_happy_count: Array[int] = [0, 1, 5, 10, 20]
const angry_money_loss: int = 10
const win_on_amount: int = 100
const lose_on_angries: int = 5

const npc_start_frequencies: Dictionary = {
	Npc.Type.Bomb: 20,
	Npc.Type.Businessman: 30,
}

const npc_spacing: int = 7
const npc_speed: int = 200
const patience_radius: int = 15

const person_patience_sec: int = 30
const person_result_sec: float = 1.0
const bomb_patience_sec = 20

const half_floor_sec: float = 0.4
const door_speed: int = 3

const npc_enter_max_sec: float = 5.0
const npc_enter_min_sec: float = 1.6
const npc_enter_shift_sec: float = 0.2
const elevator_check_interval_sec: float = 0.5

const speed_span_max_sec: float = 45.0
const speed_span_min_sec: float = 5.0
const speed_span_level_shift_sec: float = 5.0

var current_level: int = 1
var closet: Array = [Item.Type.Life, Item.Type.Life]
var floor_count: int

func _ready() -> void:
	floor_count = Nodes.Floors.get_child_count()