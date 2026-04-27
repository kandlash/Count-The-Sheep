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

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var state: State = State.WANDER
var target_sheep: Node2D = null

var _scan_timer := 0.0
var _wander_target := Vector2.ZERO
var _base_scale := Vector2.ONE
var _time := 0.0


func _ready() -> void:
	_base_scale = scale
	_pick_wander_target()


func _physics_process(delta: float) -> void:
	_time += delta
	_scan_timer -= delta

	_apply_bob()

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
	_apply_walk_animation(delta, wander_speed)

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
	_apply_walk_animation(delta, move_speed)

func _try_find_target() -> void:
	var sheep_list = get_tree().get_nodes_in_group("sheep")
	var candidates: Array = []

	for s in sheep_list:
		if not is_instance_valid(s):
			continue

		if s.get_parent().state != s.get_parent().State.BLOCKED:
			continue

		if not s.get_parent().blocked_by_fence:
			continue

		if global_position.distance_to( s.get_parent().global_position) > scan_radius:
			continue

		candidates.append(s)

	if candidates.is_empty():
		return

	target_sheep = candidates.pick_random().get_parent()
	state = State.CHASE

func _bark() -> void:
	state = State.BARK

	if is_instance_valid(target_sheep):
		target_sheep.request_jump()

	await get_tree().create_timer(0.25).timeout

	_reset()

func _reset() -> void:
	target_sheep = null
	state = State.WANDER

func _face(dir: Vector2) -> void:
	if abs(dir.x) > 0.01:
		scale.x = _base_scale.x * sign(dir.x)

func _apply_walk_animation(delta: float, speed: float) -> void:
	var t := _time * (speed / 60.0)

	var s = abs(sin(t * 10.0)) * 0.5 + 0.5

	scale.y = _base_scale.y * lerp(1.0, stretch.y, s)
	scale.x = _base_scale.x * lerp(1.0, squash.x, s)

func _apply_bob() -> void:
	position.y += sin(_time * bob_speed) * bob_amount * 0.01

func _is_valid_target(sheep: Node) -> bool:
	return sheep.state == sheep.State.BLOCKED and sheep.blocked_by_fence
