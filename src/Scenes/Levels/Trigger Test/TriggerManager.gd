extends TriggerManager

func _on_Move_Trigger_area_entered(_area: Area2D) -> void:
	play("ZoomTrigger")

func _on_Scale_Trigger_area_entered(_area: Area2D) -> void:
	play("CameraOffsetTrigger")

func _on_Rotate_Trigger_area_entered(_area: Area2D) -> void:
	play("CameraRotateTrigger")

func _on_Alpha_Trigger_area_entered(_area: Area2D) -> void:
	play("CameraStatic")

func _on_move_scale_rotate_alpha_area_entered(_area: Area2D) -> void:
	play("Move + Scale + Rotate + Alpha GridBlock_4")

func _on_pulsecolor_trigger_area_entered(_area: Area2D) -> void:
	play("Pulse GridBlock_5")
