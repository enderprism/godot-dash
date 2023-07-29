extends Area2D

@onready var player

func _ready() -> void:
	if CurrentLevel.in_editor:
		player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		player = get_node("/root/Scene/Player")

@export var y_only: bool = false
@export var x_only: bool = false
@export var one_time: bool = false
var teleported: bool = false

func _on_Teleportal_area_entered(_area: Area2D) -> void:
	if y_only:
		player.global_position.y = get_node("ExitTeleportal").get_global_position().y
	elif x_only:
		player.global_position.x = get_node("ExitTeleportal").get_global_position().x
	else:
		player.global_position = get_node("ExitTeleportal").get_global_position()
	teleported = true
	monitorable = false
	$CollisionShape2D.disabled = true
	
func _physics_process(_delta: float) -> void:
	if one_time && teleported:
		monitorable = false
		$CollisionShape2D.disabled = true
