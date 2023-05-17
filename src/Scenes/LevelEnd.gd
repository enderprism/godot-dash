extends Area2D

onready var player = get_node("/root/Scene/Player")
onready var player_icon = get_node("/root/Scene/Player/Icon")
onready var player_spider_sprites = get_node("/root/Scene/Player/SpiderSprites")
onready var player_camera = get_node("/root/Scene/Player/Camera2D")
onready var level_song = get_node("/root/Scene/LevelMusic")

func _on_player_entered(area: Area2D) -> void:
	# TODO Replace with animation
	player._x_direction = 0
	var player_tween = get_tree().create_tween().set_parallel()
	player.level_ended = true
	if LevelProgress.end_time == 0.0:
		LevelProgress.set_end_time(CurrentLevel.level_time)
	player.gamemode = "cube"
	var player_icon_ending_pos: Vector2 = Vector2($SpriteGroup.global_position.x + 120, player_camera.get_camera_screen_center().y)
	var player_icon_ending_rot: float = player_icon.global_rotation_degrees + 180
	player_tween.tween_property(player_icon, "global_position", player_icon_ending_pos, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	player_tween.tween_property(player_icon, "global_rotation_degrees", player_icon_ending_rot, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	player_tween.tween_property(player_spider_sprites, "global_position", player_icon_ending_pos, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	player_tween.tween_property(player_spider_sprites, "global_rotation_degrees", player_icon_ending_rot, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	yield(player_tween, "finished")
	$endSound.play()

func _physics_process(delta: float) -> void:
	player_camera.limit_right = global_position.x - player_camera.offset.x
	global_position.y = player_camera.get_camera_screen_center().y 
	$SpriteGroup.scale.y = player_camera.zoom.y * 1.3333333
	$SpriteGroup.scale.x = player_camera.zoom.x * 1.3333333
