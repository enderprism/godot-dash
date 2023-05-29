extends Area2D

signal yellow_gravity_portal_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("yellow_gravity_portal_entered", Callable(player, "_on_YellowGravityPortal_area_entered"))

func _on_GravityPortalA_0_area_entered(_area: Area2D) -> void:
	emit_signal("yellow_gravity_portal_entered")
