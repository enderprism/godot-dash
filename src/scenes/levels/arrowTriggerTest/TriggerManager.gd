extends TriggerManager

func _on_NormalTrigger_area_entered(area: Area2D) -> void:
	play("FakeArrowTrigger")


func _on_NormalTrigger2_area_entered(area: Area2D) -> void:
	play("BackWallGoDown")


func _on_NormalTrigger3_area_entered(area: Area2D) -> void:
	$CameraStaticManager.exit_static(0.0)
	play("ArrowTriggerTransition")
	play("RemoveExitSpikes")


func _on_ExitStatic_area_entered(area: Area2D) -> void:
	$CameraStaticManager.exit_static(0.0)
	play("ExitStatic")


func _on_NormalTrigger4_area_entered(area: Area2D) -> void:
	play("RealArrowTrigger")
