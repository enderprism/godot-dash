extends Area2D

signal spike_entered
@onready var player

func _ready() -> void:
	if CurrentLevel.in_editor:
		player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		player = get_node("/root/Scene/Player")
	connect("spike_entered", Callable(player, "_on_HazardsArea_body_entered"))

func _on_RegularSpike01_0_area_entered(_area: Area2D) -> void:
	emit_signal("spike_entered")

func _physics_process(delta: float) -> void:
	if player:
		position.x = player.position.x
