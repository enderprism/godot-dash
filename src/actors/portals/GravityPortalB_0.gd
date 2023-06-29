extends Area2D

signal blue_gravity_portal_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("blue_gravity_portal_entered", Callable(player, "_on_BlueGravityPortal_area_entered"))

func _on_GravityPortalB_0_area_entered(_area: Area2D) -> void:
	emit_signal("blue_gravity_portal_entered")
