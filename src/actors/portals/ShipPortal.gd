extends Area2D

signal ship_portal_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("ship_portal_entered", Callable(player, "_on_ShipPortal_area_entered"))

func _on_ShipPortal_0_area_entered(_area: Area2D) -> void:
	emit_signal("ship_portal_entered")
