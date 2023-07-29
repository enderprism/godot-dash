extends Area2D

signal spike_entered
@onready var player
@export var _is_saw: bool
@export_range(-360.0, 360.0, 0.01) var saw_rotation: float

func _ready() -> void:
	if CurrentLevel.in_editor:
		player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		player = get_node("/root/Scene/Player")
	connect("spike_entered", Callable(player, "_on_HazardsArea_body_entered"))

func _physics_process(delta: float) -> void:
	if _is_saw:
		$RegularSpike01.rotation_degrees += saw_rotation * delta

func _on_hazard_area_entered(_area: Area2D) -> void:
	emit_signal("spike_entered")
