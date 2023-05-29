extends Area2D

signal ufo_portal_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("ufo_portal_entered", Callable(player, "_on_UFOPortal_area_entered"))

func _on_UFOPortal_0_area_entered(_area: Area2D) -> void:
	emit_signal("ufo_portal_entered")
