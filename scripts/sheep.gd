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
@onready var vosklisatilni_znak: Sprite2D = $VosklisatilniZnak
@onready var vosklisatilni_light: PointLight2D = $VosklisatilniLight
@onready var run_timer: Timer = $run_timer
@onready var run_progressbar: ProgressBar = $Control/run_progressbar

const STEP := 16
const JUMP_STEP := 32

var state: State = State.IDLE
var want_jump := false
var is_busy := false
var move_dir := -1

var blocked_tween: Tween

# 🧠 ВАЖНО ДЛЯ СОБАКИ
var blocked_by_fence := false


# -------------------- EXPORTS --------------------

@export_group("Blocked Effect")
@export var pulse_duration := 0.3
@export var znak_scale_min := Vector2(1.0, 1.0)
@export var znak_scale_max := Vector2(1.2, 0.8)
@export var light_energy_min := 1.0
@export var light_energy_max := 1.5

@export_group("Walk")
@export var walk_squash := Vector2(1.2, 0.8)
@export var walk_duration_squash := 0.1
@export var walk_duration_move := 0.2
@export var walk_duration_restore := 0.1

@export_group("Jump")
@export var jump_squash := Vector2(1.3, 0.7)
@export var jump_stretch := Vector2(0.8, 1.2)
@export var jump_peak_height := -20.0
@export var jump_up_duration := 0.2
@export var jump_down_duration := 0.2

@export_group("Click")
@export var click_squash := Vector2(1.25, 0.75)
@export var click_duration_in := 0.08
@export var click_duration_out := 0.12

@export_group("Speed Boost")
@export var boost_multiplier := 0.5

var _has_walk_boost := false

var rarity: int = 0
var reward := 1

@export var rarity_colors := {
	0: Color.WHITE,
	1: Color(0.4, 1.0, 0.4),
	2: Color(0.4, 0.6, 1.0),
	3: Color(0.8, 0.4, 1.0),
	4: Color(1.0, 0.7, 0.2)
}

# 🧠 NEW: кто "охотится" за овцой
var hunted_by: Node = null


# -------------------- CLAIM SYSTEM --------------------

func try_claim(dog: Node) -> bool:
	if hunted_by == null or not is_instance_valid(hunted_by):
		hunted_by = dog
		return true
	return false


func release_claim(dog: Node) -> void:
	if hunted_by == dog:
		hunted_by = null

# --------------------------------------------------

func _ready() -> void:
	vosklisatilni_znak.visible = false
	vosklisatilni_light.enabled = false
	
	run_progressbar.visible = false
	run_progressbar.value = 0
	
	timer.start()

# --------------------------------------------------

func _process(delta: float) -> void:
	if not run_timer.is_stopped():
		var t := run_timer.time_left
		var total := run_timer.wait_time
		run_progressbar.value = (1.0 - t / total) * 100.0

# --------------------------------------------------
# BOOST
# --------------------------------------------------

func apply_speed_boost():
	if is_busy:
		return
	if state == State.BLOCKED:
		return
	if _has_walk_boost:
		return
	
	_has_walk_boost = true

# --------------------------------------------------
# DIRECTION
# --------------------------------------------------

func set_rarity(r: int):
	rarity = r

	if rarity_colors.has(r):
		animated_sprite_2d.modulate = rarity_colors[r]

	match r:
		0: reward = 1
		1: reward = 2
		2: reward = 5
		3: reward = 15
		4: reward = 50

	var scale_bonus := 1.0 + (r * 0.05)
	scale *= scale_bonus

func set_direction(dir: int):
	move_dir = dir
	animated_sprite_2d.flip_h = dir == 1
	ray.target_position.x = abs(ray.target_position.x) * dir

# --------------------------------------------------
# INPUT
# --------------------------------------------------

func request_jump():
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
		blocked_by_fence = false
		return true

	if col.is_in_group("sheep"):
		blocked_by_fence = false
		return false

	if col.is_in_group("fence"):
		blocked_by_fence = true
		return false

	blocked_by_fence = false
	return true

func can_jump() -> bool:
	ray.target_position = Vector2(STEP * move_dir, 0)
	ray.force_raycast_update()

	var col = ray.get_collider()
	if col == null or not col.is_in_group("fence"):
		return false

	var space = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position + Vector2(JUMP_STEP * move_dir, 0)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [self]

	var result = space.intersect_point(query, 8)

	for hit in result:
		var obj = hit.collider
		if obj.is_in_group("sheep"):
			return false
		if obj.is_in_group("fence"):
			return false

	return true

# --------------------------------------------------
# BLOCKED EFFECT
# --------------------------------------------------

func start_blocked_effect():
	if blocked_tween and blocked_tween.is_running():
		return

	vosklisatilni_znak.visible = true
	vosklisatilni_light.enabled = true

	blocked_tween = create_tween()
	blocked_tween.set_loops()

	blocked_tween.tween_property(vosklisatilni_znak, "scale", znak_scale_max, pulse_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	blocked_tween.parallel().tween_property(vosklisatilni_light, "energy", light_energy_max, pulse_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	blocked_tween.tween_property(vosklisatilni_znak, "scale", znak_scale_min, pulse_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	blocked_tween.parallel().tween_property(vosklisatilni_light, "energy", light_energy_min, pulse_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_blocked_effect():
	if blocked_tween:
		blocked_tween.kill()
		blocked_tween = null

	vosklisatilni_znak.visible = false
	vosklisatilni_light.enabled = false

	vosklisatilni_znak.scale = Vector2.ONE
	vosklisatilni_light.energy = light_energy_min

# --------------------------------------------------
# TIMER LOOP
# --------------------------------------------------

func _on_timer_timeout() -> void:
	if is_busy:
		return

	if want_jump and can_jump():
		want_jump = false
		stop_blocked_effect()
		stop_run_bar()
		run_timer.stop()
		await do_jump()
		timer.start()
		return
	elif want_jump and !can_jump():
		want_jump = false

	if can_walk():
		run_timer.stop()
		stop_run_bar()
		stop_blocked_effect()
		await do_walk()
	else:
		if run_timer.is_stopped():
			run_timer.start()
			start_run_bar()

		start_blocked_effect()
		state = State.BLOCKED

	timer.start()

# --------------------------------------------------
# ANIMATIONS
# --------------------------------------------------

func do_walk() -> void:
	is_busy = true
	state = State.WALK
	blocked_by_fence = false

	var move_time = G.sheep_walk_speed
	var restore_time = walk_duration_restore

	if _has_walk_boost:
		move_time *= boost_multiplier
		restore_time *= boost_multiplier
		_has_walk_boost = false

	var tween = create_tween()

	tween.tween_property(self, "scale", walk_squash, walk_duration_squash)
	tween.tween_property(self, "position:x", position.x + STEP * move_dir, move_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, restore_time)

	await tween.finished
	is_busy = false

func do_jump() -> void:
	stop_blocked_effect()
	stop_run_bar()
	run_timer.stop()

	is_busy = true
	state = State.JUMP
	
	var start_pos = position
	var peak_pos = start_pos + Vector2((JUMP_STEP * move_dir) / 2, jump_peak_height)
	var end_pos = start_pos + Vector2(JUMP_STEP * move_dir, 0)

	var tween = create_tween()

	tween.tween_property(self, "scale", jump_squash, 0.1)

	tween.parallel().tween_property(self, "position", peak_pos, jump_up_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(self, "scale", jump_stretch, jump_up_duration)

	await tween.finished
	
	G.world.add_jump(1, 0, rarity)

	var fall = create_tween()
	fall.tween_property(self, "position", end_pos, jump_down_duration)\
		.set_trans(Tween.TRANS_BOUNCE)

	fall.parallel().tween_property(self, "scale", Vector2.ONE, jump_down_duration)

	await fall.finished

	is_busy = false
	blocked_by_fence = false

func click_animation():
	if is_busy:
		return

	var tween = create_tween()

	tween.tween_property(self, "scale", click_squash, click_duration_in)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2.ONE, click_duration_out)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

# --------------------------------------------------

func start_run_bar():
	run_progressbar.visible = true
	run_progressbar.value = 0


func stop_run_bar():
	run_progressbar.visible = false
	run_progressbar.value = 0

func _on_run_timer_timeout() -> void:
	queue_free()
