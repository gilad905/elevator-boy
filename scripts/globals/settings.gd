extends Node

const money_by_happy_count: Array[int] = [0, 1, 5, 10, 20]
const win_on_amount: int = 50
# static var win_on_amount: int = 1 if Env.is_dev else 50
const lose_on_angries: int = 5
# var lose_on_angries: int = 100 if Env.is_dev else 5

static var npc_meta = {
	Npc.Type.Person: {
		start_frequency = 0,
		patience_sec = 30,
	},
	Npc.Type.Bomb: {
		start_frequency = 20,
		patience_sec = 20,
	},
	Npc.Type.Businessman: {
		start_frequency = 30,
		patience_sec = 20,
		guide = "businessman",
	},
	Npc.Type.Karen: {
		start_frequency = 40,
		patience_sec = 20,
		guide = "karen",
		money_loss = 50,
		angry_sound = "WomanGrunt",
	}
}

const item_meta = {
	Item.Type.Life: {
		frequency = 0,
	},
	Item.Type.Broom: {
		frequency = 3,
		# guide = "broom",
	},
}

static var modal_meta: Dictionary = {
	"welcome": preload("res://scenes/modals/modal_welcome.tscn"),
	"introduction": preload("res://scenes/modals/modal_introduction.tscn"),
	"start_level": preload("res://scenes/modals/modal_start_level.tscn"),
	"used_life": preload("res://scenes/modals/modal_used_life.tscn"),
	"game_over": preload("res://scenes/modals/modal_game_over.tscn"),
	"paused": preload("res://scenes/modals/modal_paused.tscn"),
	"businessman": preload("res://scenes/modals/modal_businessman.tscn"),
	"karen": preload("res://scenes/modals/modal_karen.tscn"),
}

const npc_spacing: int = 7
const npc_speed: int = 200
const patience_radius: int = 15
const npc_result_duration: float = 1.0
const npc_fall_duration: float = 2

const half_floor_sec: float = 0.4
const door_speed: int = 3

const npc_enter_max_sec: float = 5.0
const npc_enter_min_sec: float = 1.6
const npc_enter_shift_sec: float = 0.2
const elevator_check_interval_sec: float = 0.5

const speed_span_max_sec: float = 45.0
const speed_span_min_sec: float = 5.0
const speed_span_level_shift_sec: float = 5.0

const item_spacing: int = 2
const item_size: int = 50
const item_speed: int = 600

static var floor_count: int

func _ready() -> void:
	print("-- Env:     %s" % ("DEV" if Env.is_dev else "PROD"))
	print("-- Version: %s" % Env.version)
	floor_count = Nodes.Floors.get_child_count()