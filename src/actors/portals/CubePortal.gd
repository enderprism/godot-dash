extends Area2D

signal portal_entered

@export var freefly: bool = true
@export var custom: bool = false
@onready var player: = get_node("/root/Scene/Player")
@onready var ground_manager = get_node("/root/Scene/GroundManager")
var ground_radius: float = 61*5

func _on_CubePortal_0_area_entered(_area: Area2D) -> void:
	connect("portal_entered", Callable(ground_manager, "_freefly_setter").bind(freefly, ground_radius, global_position.y, custom))
	emit_signal("portal_entered")

func _ready() -> void:
	connect("portal_entered", Callable(player, "_on_CubePortal_area_entered"))
