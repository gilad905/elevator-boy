extends Node

const _export_settings = preload("res://resources/export_settings.gd").obj
const is_dev = _export_settings.is_dev
const version = _export_settings.version

const money_by_happy_count: Array[int] = [0, 1, 5, 10, 20]
const angry_money_loss: int = 5
# const win_on_amount: int = 50
const win_on_amount: int = 1 if is_dev else 50
const lose_on_angries: int = 5
# const lose_on_angries: int = 100 if is_dev else 5

const npc_meta = {
	Npc.Type.Person: {
		start_frequency = 0,
		patience_sec = 30,
	},
	Npc.Type.Bomb: {
		# start_frequency = 2 if is_dev else 20,
		start_frequency = 20,
		patience_sec = 20,
	},
	Npc.Type.Businessman: {
		# start_frequency = -1 if is_dev else 30,
		start_frequency = 30,
		patience_sec = 20,
	},
}

const item_meta = {
	Item.Type.Life: {
		frequency = 0,
	},
	Item.Type.Broom: {
		frequency = 3,
	},
}

const modal_meta: Dictionary = {
	welcome = "ELEVATOR BOY",
	game_over = "GAME OVER",
	used_life = "YOU USED ONE LIFE.\nRETRY LEVEL.",
	paused = "PAUSED",
}

const npc_spacing: int = 7
const npc_speed: int = 200
const patience_radius: int = 15
const npc_result_sec: float = 1.0

const half_floor_sec: float = 0.4
const door_speed: int = 3

const npc_enter_max_sec: float = 5.0
const npc_enter_min_sec: float = 1.6
const npc_enter_shift_sec: float = 0.2
const elevator_check_interval_sec: float = 0.5

const speed_span_max_sec: float = 45.0
const speed_span_min_sec: float = 5.0
const speed_span_level_shift_sec: float = 5.0

static var floor_count: int

func _ready() -> void:
	floor_count = Nodes.Floors.get_child_count()
