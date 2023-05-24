extends TriggerManager

func _on_SpikeChain1Trigger_area_entered(area: Area2D) -> void:
	play("SpikeChain1Down")


func _on_SpikeChain2Trigger2_area_entered(area: Area2D) -> void:
	play("SpikeChain2Down")
