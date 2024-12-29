@tool

extends Label
@export var icon: CompressedTexture2D
@export var icon_scale: float

func _ready() -> void:
	$Icon.texture = icon
	$Icon.scale.x = icon_scale
	$Icon.scale.y = icon_scale
