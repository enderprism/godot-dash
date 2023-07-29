extends Node2D

@export var camera_control_scheme: CurrentLevel.CameraControlScheme
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CurrentLevel.editor_active_camera = CurrentLevel.ActiveCamera.EDITORCAMERA
	CurrentLevel.in_editor = true

func _process(delta: float) -> void:
	CurrentLevel.editor_camera_control_scheme = camera_control_scheme


func _on_playtest_pressed() -> void:
	CurrentLevel.editor_is_playtesting = true
	get_node("GameScene/Player").show()
