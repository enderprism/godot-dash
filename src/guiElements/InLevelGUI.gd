extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = !CurrentLevel.in_editor
