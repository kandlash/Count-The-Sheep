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

const STEP := 16
const JUMP_STEP := 32

var state: State = State.IDLE
var want_jump := false
var is_busy := false
var move_dir := -1

var blocked_tween: Tween

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
# ------------------------------------------------

func _ready() -> void:
	vosklisatilni_znak.visible = false
	vosklisatilni_light.enabled = false
	timer.start()

# --------------------------------------------------
# DIRECTION
# --------------------------------------------------

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
		return true
	
	if col.is_in_group("sheep"):
		return false
	
	if col.is_in_group("fence"):
		return false
	
	return true

func can_jump() -> bool:
	ray.target_position = Vector2(STEP * move_dir, 0)
	ray.force_raycast_update()

	var col = ray.get_collider()
	if col == null or not col.is_in_group("fence"):
		return false

	ray.target_position = Vector2(JUMP_STEP * move_dir, 0)
	ray.force_raycast_update()

	var col2 = ray.get_collider()
	if col2 != null and col2.is_in_group("sheep"):
		return false

	return true

# --------------------------------------------------
# BLOCKED EFFECT
# --------------------------------------------------

func start_blocked_effect():
	if blocked_tween and blocked_tween.is_running():
		return
		
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_BLOCKED)
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
# TIMER
# --------------------------------------------------

func _on_timer_timeout() -> void:
	if is_busy:
		return
	
	if want_jump and can_jump():
		want_jump = false
		stop_blocked_effect()
		await do_jump()
		timer.start()
		return
	
	if can_walk():
		stop_blocked_effect()
		await do_walk()
	else:
		start_blocked_effect()
		state = State.BLOCKED
	
	timer.start()

# --------------------------------------------------
# ANIMATIONS
# --------------------------------------------------

func do_walk() -> void:
	is_busy = true
	state = State.WALK

	var tween = create_tween()

	tween.tween_property(self, "scale", walk_squash, walk_duration_squash)
	tween.tween_property(self, "position:x", position.x + STEP * move_dir, walk_duration_move)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), walk_duration_restore)

	await tween.finished
	is_busy = false

func do_jump() -> void:
	stop_blocked_effect()

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

	var fall = create_tween()
	fall.tween_property(self, "position", end_pos, jump_down_duration)\
		.set_trans(Tween.TRANS_BOUNCE)

	fall.parallel().tween_property(self, "scale", Vector2(1, 1), jump_down_duration)

	await fall.finished
	is_busy = false


func click_animation():
	# не перебиваем важные анимации
	if is_busy:
		return
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", click_squash, click_duration_in)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", Vector2.ONE, click_duration_out)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
