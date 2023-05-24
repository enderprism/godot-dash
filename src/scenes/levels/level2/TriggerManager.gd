extends TriggerManager

func _on_CameraStatic_area_entered(area: Area2D) -> void:
	play("Enter CameraStatic Spider")

func _on_CameraStatic2_area_entered(area: Area2D) -> void:
	play("Exit CameraStatic Spider")
