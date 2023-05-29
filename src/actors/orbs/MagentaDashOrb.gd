extends Area2D

signal magenta_dash_orb_entered
signal magenta_dash_orb_exited

@export var reverse: bool = false
@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("magenta_dash_orb_entered", Callable(player, "_on_MagentaDashOrb_area_entered").bind(rotation, reverse)) # connect orb function to player
	connect("magenta_dash_orb_exited", Callable(player, "_on_MagentaDashOrb_area_exited")) # connect orb function to player

func _on_MagentaDashOrb_area_entered(_area: Area2D) -> void:
	emit_signal("magenta_dash_orb_entered")

func _on_MagentaDashOrb_area_exited(_area: Area2D) -> void:
	emit_signal("magenta_dash_orb_exited")
