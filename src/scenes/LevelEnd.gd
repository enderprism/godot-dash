extends Area2D

@onready var player
@onready var player_icon
@onready var player_spider_sprites
@onready var player_camera
@onready var level_song

func _ready() -> void:
	if CurrentLevel.in_editor:
		player = get_node("/root/LevelEditor/GameScene/Player")
		player_icon = get_node("/root/LevelEditor/GameScene/Player/Icon")
		player_spider_sprites = get_node("/root/LevelEditor/GameScene/Player/SpiderSprites")
		player_camera = get_node("/root/LevelEditor/GameScene/PlayerCamera")
		level_song = get_node("/root/LevelEditor/GameScene/LevelMusic")
	else:
		player = get_node("/root/Scene/Player")
		player_icon = get_node("/root/Scene/Player/Icon")
		player_spider_sprites = get_node("/root/Scene/Player/SpiderSprites")
		player_camera = get_node("/root/Scene/PlayerCamera")
		level_song = get_node("/root/Scene/LevelMusic")

func _on_player_entered(_body: PhysicsBody2D) -> void:
	# TODO Replace with animation
	player._x_direction = 0
	var player_tween = get_tree().create_tween().set_parallel()
	player.level_ended = true
	if LevelProgress.end_time == 0.0:
		LevelProgress.set_end_time(CurrentLevel.level_time)
	player.gamemode = "cube"
	var player_icon_ending_pos: Vector2 = Vector2($SpriteGroup.global_position.x + 120, player_camera.get_screen_center_position().y)
	var player_icon_ending_rot: float = player_icon.global_rotation_degrees + 360
	player_tween.tween_property(player_icon, "global_position:x", player_icon_ending_pos.x, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	player_tween.tween_property(player_icon, "global_position:y", player_icon_ending_pos.y, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	player_tween.tween_property(player_icon, "global_rotation_degrees", player_icon_ending_rot, 1.0).set_trans(Tween.TRANS_LINEAR)
	player_tween.tween_property(player_spider_sprites, "global_position:x", player_icon_ending_pos.x, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	player_tween.tween_property(player_spider_sprites, "global_position:y", player_icon_ending_pos.y, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	player_tween.tween_property(player_spider_sprites, "global_rotation_degrees", player_icon_ending_rot, 1.0).set_trans(Tween.TRANS_LINEAR)
	await player_tween.finished
	$endSound.play()

func _physics_process(_delta: float) -> void:
	if player_camera:
		player_camera.limit_right = global_position.x - player_camera.offset.x
		global_position.y = player_camera.get_screen_center_position().y
		scale.y = 1/player_camera.zoom.y
		scale.x = 1/player_camera.zoom.y
