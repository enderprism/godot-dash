extends StaticBody2D

tool
export var base_texture: Resource
export var detail_texture: Resource
export var base_color: Color = Color("ffffff")
export var detail_color: Color = Color("ffffff")

func _physics_process(delta: float) -> void:
	$Base.texture = base_texture
	$Detail.texture = detail_texture
	$Base.modulate = base_color
	$Detail.modulate = detail_color
	
