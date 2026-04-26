extends PointLight2D

@export var follow_speed := 10.0

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	# плавное движение
	global_position = global_position.lerp(mouse_pos, delta * follow_speed)
