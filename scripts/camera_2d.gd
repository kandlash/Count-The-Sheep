extends Camera2D

@export var max_offset := 10.0
@export var follow_speed := 5.0
@export var ui_strength := 0.5

@onready var ui_holder: Node2D = $UIHolder

var target_offset := Vector2.ZERO
var current_ui_offset := Vector2.ZERO

func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()

	var center = viewport_size / 2.0
	
	# направление от центра (-1..1)
	var dir = (mouse_pos - center) / center
	dir = dir.clamp(Vector2(-1, -1), Vector2(1, 1))

	target_offset = dir * max_offset

	# движение камеры
	offset = offset.lerp(target_offset, delta * follow_speed)

	# движение UI (медленнее и с инерцией)
	var ui_target = target_offset * ui_strength
	current_ui_offset = current_ui_offset.lerp(ui_target, delta * follow_speed)
	ui_holder.position = current_ui_offset
