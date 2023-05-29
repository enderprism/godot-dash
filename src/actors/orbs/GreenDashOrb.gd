extends Area2D

signal green_dash_orb_entered
signal green_dash_orb_exited

@export var reverse: bool = false
@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("green_dash_orb_entered", Callable(player, "_on_GreenDashOrb_area_entered").bind(rotation, reverse)) # connect orb function to player
	connect("green_dash_orb_exited", Callable(player, "_on_GreenDashOrb_area_exited")) # connect orb function to player

func _on_GreenDashOrb_area_entered(_area: Area2D) -> void:
	emit_signal("green_dash_orb_entered")

func _on_GreenDashOrb_area_exited(_area: Area2D) -> void:
	emit_signal("green_dash_orb_exited")
