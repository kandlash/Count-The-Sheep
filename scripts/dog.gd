extends Node2D
class_name Dog

enum State {
	WANDER,
	CHASE,
	BARK
}

@export var scan_radius := 600.0
@export var move_speed := 90.0
@export var bark_distance := 26.0
@export var scan_interval := 0.3

@export var wander_radius := 40.0
@export var wander_speed := 25.0

@export var bob_amount := 2.5
@export var bob_speed := 8.0

@export var squash := Vector2(1.15, 0.85)
@export var stretch := Vector2(0.9, 1.1)

@export var turn_duration := 0.12

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var state: State = State.WANDER
var target_sheep: Node2D = null

var _scan_timer := 0.0
var _wander_target := Vector2.ZERO
var _base_scale := Vector2.ONE
var _time := 0.0

var _facing := 1.0

var _turning := false
var _turn_t := 0.0
var _turn_from := 1.0
var _turn_to := 1.0


func _ready() -> void:
	_base_scale = scale
	_pick_wander_target()


func _physics_process(delta: float) -> void:
	_time += delta
	_scan_timer -= delta

	_apply_bob()

	_update_turn(delta)

	match state:
		State.WANDER:
			_wander(delta)
			if _scan_timer <= 0.0:
				_scan_timer = scan_interval
				_try_find_target()

		State.CHASE:
			_chase(delta)

		State.BARK:
			pass


func _wander(delta: float) -> void:
	var dir = _wander_target - global_position

	if dir.length() < 5.0:
		_pick_wander_target()

	dir = dir.normalized()

	global_position += dir * wander_speed * delta

	_face(dir)
	_apply_walk_animation(wander_speed)


func _pick_wander_target() -> void:
	_wander_target = global_position + Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)


func _chase(delta: float) -> void:
	if not is_instance_valid(target_sheep):
		_reset()
		return

	if not _is_valid_target(target_sheep):
		_reset()
		return

	var dir = target_sheep.global_position - global_position
	var dist = dir.length()

	if dist <= bark_distance:
		_bark()
		return

	dir = dir.normalized()

	global_position += dir * move_speed * delta

	_face(dir)
	_apply_walk_animation(move_speed)


func _try_find_target() -> void:
	var sheep_list = get_tree().get_nodes_in_group("sheep")
	var candidates: Array = []

	for s in sheep_list:
		if not is_instance_valid(s):
			continue

		var sheep = s.get_parent()

		if sheep.state != sheep.State.BLOCKED:
			continue

		if not sheep.blocked_by_fence:
			continue

		if sheep.hunted_by != null:
			continue

		if global_position.distance_to(sheep.global_position) > scan_radius:
			continue

		candidates.append(sheep)

	if candidates.is_empty():
		return

	candidates.shuffle()

	for s in candidates:
		if s.try_claim(self):
			target_sheep = s
			state = State.CHASE
			return


func _bark() -> void:
	state = State.BARK

	if is_instance_valid(target_sheep):
		target_sheep.request_jump()

	await get_tree().create_timer(0.25).timeout

	_reset()


func _reset() -> void:
	target_sheep = null
	state = State.WANDER


# --- TURN SYSTEM (SMOOTH FLIP) ---

func _face(dir: Vector2) -> void:
	if abs(dir.x) < 0.01:
		return

	var new_facing = sign(dir.x)

	if new_facing != _facing and not _turning:
		_start_turn(new_facing)


func _start_turn(to: float) -> void:
	_turning = true
	_turn_t = 0.0
	_turn_from = _facing
	_turn_to = to


func _update_turn(delta: float) -> void:
	if not _turning:
		return

	_turn_t += delta / turn_duration

	var t = clamp(_turn_t, 0.0, 1.0)

	# squash-in -> flip -> squash-out
	var squash_x = 1.0

	if t < 0.5:
		squash_x = lerp(1.0, 0.2, t * 2.0)
	else:
		squash_x = lerp(0.2, 1.0, (t - 0.5) * 2.0)

	var y = _base_scale.y

	scale = Vector2(_base_scale.x * squash_x * _facing, y)

	if t >= 1.0:
		_turning = false
		_facing = _turn_to


func _apply_walk_animation(speed: float) -> void:
	var t := _time * (speed / 60.0)
	var s = abs(sin(t * 10.0)) * 0.5 + 0.5

	var y_scale = _base_scale.y * lerp(1.0, stretch.y, s)

	# только если НЕ в повороте
	if not _turning:
		scale = Vector2(_base_scale.x * _facing, y_scale)


func _apply_bob() -> void:
	position.y += sin(_time * bob_speed) * bob_amount * 0.01


func _is_valid_target(sheep: Node) -> bool:
	return sheep.state == sheep.State.BLOCKED and sheep.blocked_by_fence
