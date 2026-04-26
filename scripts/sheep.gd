extends Node2D

enum State {
	IDLE,
	WALK,
	JUMP,
	BLOCKED
}

@onready var timer: Timer = $Timer
@onready var ray: RayCast2D = $RayCast2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const STEP := 16
const JUMP_STEP := 32 # важно: прыжок через клетку

var state: State = State.IDLE
var want_jump := false
var is_busy := false

var move_dir := -1 # по дефолту влево


func _ready() -> void:
	timer.start()

# --------------------------------------------------
# DIRECTION
# --------------------------------------------------

func set_direction(dir: int):
	move_dir = dir
	
	# флип спрайта
	animated_sprite_2d.flip_h = dir == 1
	
	# развернуть raycast
	ray.target_position.x = abs(ray.target_position.x) * dir


# --------------------------------------------------
# INPUT (из ClickManager)
# --------------------------------------------------

func request_jump():
	print("request to jump!")
	if not is_busy:
		want_jump = true


# --------------------------------------------------
# CHECKS
# --------------------------------------------------

func can_walk() -> bool:
	ray.target_position = Vector2(STEP * move_dir, 0)
	ray.force_raycast_update()

	var col = ray.get_collider()
	if col == null:
		return true
	
	if col.is_in_group("sheep"):
		return false
	
	if col.is_in_group("fence"):
		return false
	
	return true


func can_jump() -> bool:
	# проверяем забор перед овцой
	ray.target_position = Vector2(STEP * move_dir, 0)
	ray.force_raycast_update()

	var col = ray.get_collider()
	if col == null or not col.is_in_group("fence"):
		return false

	# проверяем клетку ЗА забором
	ray.target_position = Vector2(JUMP_STEP * move_dir, 0)
	ray.force_raycast_update()

	var col2 = ray.get_collider()
	if col2 != null and col2.is_in_group("sheep"):
		return false

	return true


# --------------------------------------------------
# TIMER TICK
# --------------------------------------------------

func _on_timer_timeout() -> void:
	if is_busy:
		return
	
	if want_jump and can_jump():
		want_jump = false
		await do_jump()
		timer.start()
		return
	
	if can_walk():
		await do_walk()
	else:
		state = State.BLOCKED
	
	timer.start()


# --------------------------------------------------
# ANIMATIONS
# --------------------------------------------------

func do_walk() -> void:
	is_busy = true
	state = State.WALK

	var tween = create_tween()

	tween.tween_property(self, "scale", Vector2(1.2, 0.8), 0.1)
	tween.tween_property(self, "position:x", position.x + STEP * move_dir, 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)

	await tween.finished
	is_busy = false


func do_jump() -> void:
	is_busy = true
	state = State.JUMP

	var start_pos = position
	var peak_pos = start_pos + Vector2((JUMP_STEP * move_dir) / 2, -20)
	var end_pos = start_pos + Vector2(JUMP_STEP * move_dir, 0)

	var tween = create_tween()

	# сжатие перед прыжком
	tween.tween_property(self, "scale", Vector2(1.3, 0.7), 0.1)

	# взлет
	tween.parallel().tween_property(self, "position", peak_pos, 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(self, "scale", Vector2(0.8, 1.2), 0.2)

	await tween.finished

	# падение
	var fall = create_tween()
	fall.tween_property(self, "position", end_pos, 0.2)\
		.set_trans(Tween.TRANS_BOUNCE)

	fall.parallel().tween_property(self, "scale", Vector2(1, 1), 0.2)

	await fall.finished
	is_busy = false
