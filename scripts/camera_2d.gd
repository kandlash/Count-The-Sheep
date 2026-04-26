extends Camera2D

@export var max_offset := 10.0   # максимальное смещение камеры
@export var follow_speed := 5.0   # плавность (чем больше — тем быстрее догоняет)

var target_offset := Vector2.ZERO

func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()

	# центр экрана
	var center = viewport_size / 2.0
	
	# направление от центра к курсору (-1..1)
	var dir = (mouse_pos - center) / center
	dir = dir.clamp(Vector2(-1, -1), Vector2(1, 1))

	# целевое смещение
	target_offset = dir * max_offset

	# плавное движение камеры
	offset = offset.lerp(target_offset, delta * follow_speed)
