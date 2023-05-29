extends Area2D

signal speed_portal_2x_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("speed_portal_2x_entered", Callable(player, "_on_SpeedPortal2x_area_entered"))

func _on_SpeedPortal2x_area_entered(area: Area2D) -> void:
	emit_signal("speed_portal_2x_entered")
