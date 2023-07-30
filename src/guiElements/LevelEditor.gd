extends Node2D

@export var camera_control_scheme: CurrentLevel.CameraControlScheme = CurrentLevel.CameraControlScheme.GEOMETRYDASH
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CurrentLevel.editor_active_camera = CurrentLevel.ActiveCamera.EDITORCAMERA
	CurrentLevel.in_editor = true
	$GameScene/GroundManager/Ground_Top.hide()
	$GameScene/GroundManager/Ground_Bottom/Ground_Bottom_OBJ/GroundSprites/ColorRect.hide()

func _process(delta: float) -> void:
	CurrentLevel.editor_camera_control_scheme = camera_control_scheme


func _on_playtest_pressed() -> void:
	CurrentLevel.editor_is_playtesting = true
	get_node("GameScene/Player").show()

func _hide_ground():
	$GameScene/GroundManager/Ground_Bottom/Ground_Bottom_OBJ.hide()
	$GameScene/GroundManager/Ground_Bottom/Line_Bottom.scale_multiplier = 10

func _show_ground():
	$GameScene/GroundManager/Ground_Bottom/Ground_Bottom_OBJ.show()
	$GameScene/GroundManager/Ground_Bottom/Line_Bottom.scale_multiplier = 1
