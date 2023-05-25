extends ColorRect

signal fade_finished

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func fade_in() -> void:
	$AnimationPlayer.play("FadeIn")

func fade_out() -> void:
	$AnimationPlayer.play("FadeOut")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	emit_signal("fade_finished")
