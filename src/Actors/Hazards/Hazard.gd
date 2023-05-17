extends Area2D

signal spike_entered
onready var player: = get_node("/root/Scene/Player")
export var _is_saw: bool
export (float, -360.0, 360.0) var saw_rotation

func _ready() -> void:
	connect("spike_entered", player, "_on_HazardsArea_body_entered")

func _physics_process(delta: float) -> void:
	if _is_saw:
		$RegularSpike01.rotation_degrees += saw_rotation * delta

func _on_hazard_area_entered(_area: Area2D) -> void:
	emit_signal("spike_entered")
