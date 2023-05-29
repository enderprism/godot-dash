extends Area2D

signal spike_entered
@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("spike_entered", Callable(player, "_on_HazardsArea_body_entered"))

func _on_RegularSpike01_0_area_entered(_area: Area2D) -> void:
	emit_signal("spike_entered")

func _physics_process(delta: float) -> void:
	position.x = player.position.x
