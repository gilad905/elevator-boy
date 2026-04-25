extends Node

const money_by_happy_count: Array[int] = [0, 1, 5, 10, 20]
# const win_on_amount: int = 50
static var win_on_amount: int = 1 if Env.is_dev else 50
const lose_on_angries: int = 5
# var lose_on_angries: int = 100 if Env.is_dev else 5

const npc_enter_interval: float = 5.0
const npc_spacing: int = 7
const npc_speed: int = 200
const npc_patience_decrease_per_level: float = 0.05
const npc_patience_decrease_max: float = 0.33
const npc_patience_radius: int = 15
const npc_result_duration: float = 1.0
const npc_fall_duration: float = 2

const elevator_half_floor_sec: float = 0.4
const elevator_door_speed: int = 3
# const elevator_check_interval_sec: float = 0.5
const engine_multiplier: float = 2
const engine_duration: float = 20.0

const item_spacing: int = 2
const item_size: int = 50
const item_speed: int = 600
const life_min_amount_for_roll: int = 2

const levels_per_building: int = 3

static var buildings = [
	preload("res://scenes/backgrounds/backyard.tscn"),
	preload("res://scenes/backgrounds/street.tscn"),
	preload("res://scenes/backgrounds/stocks.tscn"),
]

static var npc_meta = {
	Npc.Type.Person: {
		get_weight = func(_lev): return 10,
		patience_sec = 30,
	},
	Npc.Type.Businessman: {
		get_weight = func(lev): return 0 if lev == 1 else 1,
		patience_sec = 20,
		guide = "businessman",
	},
	Npc.Type.Bomb: {
		get_weight = func(lev): return lev - 1,
		patience_sec = 20,
		guide = "bomb",
	},
	Npc.Type.Karen: {
		get_weight = func(lev): return lev - 3,
		patience_sec = 20,
		money_loss = 50,
		guide = "karen",
		angry_sound = "WomanGrunt",
	}
}

const item_meta = {
	Item.Type.Life: {
		roll_weight = 1,
	},
	Item.Type.Broom: {
		roll_weight = 6,
		guide = "broom",
	},
	Item.Type.Engine: {
		roll_weight = 6,
		guide = "engine",
	},
}

static var modal_meta: Dictionary = {
	# modals
	"welcome": preload("res://scenes/modals/modal_welcome.tscn"),
	"start_level": preload("res://scenes/modals/modal_start_level.tscn"),
	"paused": preload("res://scenes/modals/modal_paused.tscn"),
	"used_life": preload("res://scenes/modals/modal_used_life.tscn"),
	"game_over": preload("res://scenes/modals/modal_game_over.tscn"),

	# guides
	"introduction": preload("res://scenes/guides/guide_introduction.tscn"),
	"businessman": preload("res://scenes/guides/guide_businessman.tscn"),
	"bomb": preload("res://scenes/guides/guide_bomb.tscn"),
	"karen": preload("res://scenes/guides/guide_karen.tscn"),
	"broom": preload("res://scenes/guides/guide_broom.tscn"),
	"engine": preload("res://scenes/guides/guide_engine.tscn"),
	
	# popups
	"popup_win": preload("res://scenes/popups/popup_win.tscn"),
}

static var floor_count: int

func _ready() -> void:
	print("-- Env:     %s" % ("DEV" if Env.is_dev else "PROD"))
	print("-- Version: %s" % Env.version)
	floor_count = Nodes.Floors.get_child_count()