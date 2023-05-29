extends Area2D

signal ball_portal_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("ball_portal_entered", Callable(player, "_on_BallPortal_area_entered"))

func _on_BallPortal_0_area_entered(area: Area2D) -> void:
	emit_signal("ball_portal_entered")
