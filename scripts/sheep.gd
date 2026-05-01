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
@onready var land_particle: CPUParticles2D = $land_particle

@onready var jump_point_label: RichTextLabel = $Control/jump_point_label
@onready var name_label: Label = $Control/name_label

const STEP := 16
const JUMP_STEP := 32

var state: State = State.IDLE
var want_jump := false
var is_busy := false
var move_dir := -1

var blocked_tween: Tween
var blocked_by_fence := false

# -------------------- POPUP --------------------

var _label_start_pos: Vector2

func show_jump_points():
	jump_point_label.visible = true
	jump_point_label.clear()

	var col: Color = rarity_colors.get(rarity, Color.WHITE)
	var hex := col.to_html(false)

	var text := "[center][color=#%s][font_size=10]+1[/font_size][/color][/center]" % hex
	jump_point_label.append_text(text)

	jump_point_label.position = _label_start_pos
	jump_point_label.modulate.a = 1.0

	var angle := deg_to_rad(randf_range(-15.0, 15.0))
	var distance := randf_range(5.0, 10.0)
	var offset := Vector2(cos(angle), sin(angle)) * distance
	offset.y -= 0.0

	var target_pos := _label_start_pos + offset

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(jump_point_label, "position", target_pos, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(jump_point_label, "modulate:a", 0.0, 1.5)

	await tween.finished

	jump_point_label.visible = false
	jump_point_label.position = _label_start_pos
	jump_point_label.modulate.a = 1.0

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
var reward := 1.0

const COMMON_SHEEP = preload("uid://cg32ypr50jcma")
const EPIC_SHEEP = preload("uid://c8oh3lky5wwob")
const LEGEND_SHEEP = preload("uid://cpkbwotwgcpdv")
const RARE_SHEEP = preload("uid://bol8n2qff8iyn")
const UNCOMMON_SHEEP = preload("uid://c04tagakc6v1h")


@export var rarity_colors := {
	0: Color.WHITE,
	1: Color(0.4, 1.0, 0.4),
	2: Color(0.4, 0.6, 1.0),
	3: Color(0.8, 0.4, 1.0),
	4: Color(1.0, 0.7, 0.2)
}

var hunted_by: Node = null

var panic_started := false
var znak_base_pos: Vector2

# --------------------------------------------------

func _ready() -> void:
	znak_base_pos = vosklisatilni_znak.position
	vosklisatilni_znak.visible = false
	vosklisatilni_light.enabled = false
	
	run_progressbar.visible = false
	run_progressbar.value = 0
	
	jump_point_label.visible = false
	_label_start_pos = jump_point_label.position
	run_timer.wait_time = G.sheep_run_timer
	timer.start()
	name_label.text = G.get_random_name()

# --------------------------------------------------
var want_to_run = false
const WOOL_EXPLOSION = preload("uid://c1clqw5ixuui1")

func _process(delta: float) -> void:
	if not run_timer.is_stopped():
		var t := run_timer.time_left
		var total := run_timer.wait_time
		
		# запуск паники за 1.5 секунды
		if t <= 1.5 and !panic_started:
			start_panic_effect()

		# звук за 1 секунду (как у тебя было)
		if t <= 1.5 and !want_to_run:
			var wool_explosion = WOOL_EXPLOSION.instantiate()
			add_child(wool_explosion)
			wool_explosion.global_position = global_position
			wool_explosion.scale *= 5
			wool_explosion.play_explosion()
			want_to_run = true
			AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.SHEEP_BLOCKED)
			await get_tree().create_timer(0.5).timeout
			wool_explosion.queue_free()

		run_progressbar.value = (1.0 - t / total) * 100.0

		# тряска
		if panic_started:
			var shake_strength := 1.0
			vosklisatilni_znak.position = znak_base_pos + Vector2(
				randf_range(-shake_strength, shake_strength),
				randf_range(-shake_strength, shake_strength)
			)

func start_panic_effect():
	panic_started = true

	vosklisatilni_znak.visible = true

	var tween = create_tween()
	tween.tween_property(vosklisatilni_znak, "scale", Vector2(1.4, 1.4), 0.2)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

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

func set_rarity(r: int):
	rarity = r

	match r:
		0:
			# обычная — оставляем дефолт
			pass
		1:
			animated_sprite_2d.sprite_frames = UNCOMMON_SHEEP
		2:
			animated_sprite_2d.sprite_frames = RARE_SHEEP
		3:
			animated_sprite_2d.sprite_frames = EPIC_SHEEP
		4:
			animated_sprite_2d.sprite_frames = LEGEND_SHEEP

	# сбрасываем цвет (если раньше использовал)
	animated_sprite_2d.modulate = Color.WHITE

	# reward как было
	match r:
		0: reward = 0.1
		1: reward = 0.5
		2: reward = 1.0
		3: reward = 3.0
		4: reward = 10.0

	var scale_bonus := 1.0 + (r * 0.05)
	scale *= scale_bonus

func set_direction(dir: int):
	move_dir = dir
	animated_sprite_2d.flip_h = dir == 1
	ray.target_position.x = abs(ray.target_position.x) * dir

# --------------------------------------------------

func request_jump():
	if not is_busy:
		want_jump = true

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

func start_blocked_effect():
	if blocked_tween and blocked_tween.is_running():
		return

	vosklisatilni_znak.visible = true
	vosklisatilni_light.enabled = true

	blocked_tween = create_tween()
	blocked_tween.set_loops()

	blocked_tween.tween_property(vosklisatilni_znak, "scale", znak_scale_max, pulse_duration)
	blocked_tween.parallel().tween_property(vosklisatilni_light, "energy", light_energy_max, pulse_duration)
	blocked_tween.tween_property(vosklisatilni_znak, "scale", znak_scale_min, pulse_duration)
	blocked_tween.parallel().tween_property(vosklisatilni_light, "energy", light_energy_min, pulse_duration)
	panic_started = false
	vosklisatilni_znak.position = znak_base_pos
	vosklisatilni_znak.scale = Vector2.ONE

func stop_blocked_effect():
	if blocked_tween:
		blocked_tween.kill()
		blocked_tween = null

	vosklisatilni_znak.visible = false
	vosklisatilni_light.enabled = false

	vosklisatilni_znak.scale = Vector2.ONE
	vosklisatilni_light.energy = light_energy_min

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

func do_walk() -> void:
	is_busy = true
	state = State.WALK
	blocked_by_fence = false

	var move_time = G.sheep_walk_speed
	var restore_time = walk_duration_restore
	want_to_run = false
	if _has_walk_boost:
		move_time *= boost_multiplier
		restore_time *= boost_multiplier
		_has_walk_boost = false

	var tween = create_tween()

	tween.tween_property(self, "scale", walk_squash, walk_duration_squash)
	tween.tween_property(self, "position:x", position.x + STEP * move_dir, move_time)
	tween.tween_property(self, "scale", Vector2.ONE, restore_time)

	await tween.finished
	is_busy = false

func do_jump() -> void:
	stop_blocked_effect()
	stop_run_bar()
	run_timer.stop()
	want_to_run = false
	is_busy = true
	state = State.JUMP
	
	var start_pos = position
	var peak_pos = start_pos + Vector2((JUMP_STEP * move_dir) / 2, jump_peak_height)
	var end_pos = start_pos + Vector2(JUMP_STEP * move_dir, 0)

	var tween = create_tween()

	tween.tween_property(self, "scale", jump_squash, 0.1)
	tween.parallel().tween_property(self, "position", peak_pos, jump_up_duration)
	tween.parallel().tween_property(self, "scale", jump_stretch, jump_up_duration)

	await tween.finished
	
	G.world.add_jump(1, 0, rarity)
	show_jump_points()

	var fall = create_tween()
	fall.tween_property(self, "position", end_pos, jump_down_duration)
	fall.parallel().tween_property(self, "scale", Vector2.ONE, jump_down_duration)

	await fall.finished
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.SHEEP_LAND)
	land_particle.emitting = true
	is_busy = false
	blocked_by_fence = false

func click_animation():
	if is_busy:
		return

	var tween = create_tween()
	tween.tween_property(self, "scale", click_squash, click_duration_in)
	tween.tween_property(self, "scale", Vector2.ONE, click_duration_out)

# --------------------------------------------------

func try_claim(dog: Node) -> bool:
	if hunted_by == null or not is_instance_valid(hunted_by):
		hunted_by = dog
		return true
	return false

func release_claim(dog: Node) -> void:
	if hunted_by == dog:
		hunted_by = null

func start_run_bar():
	run_progressbar.visible = true
	run_progressbar.value = 0

func stop_run_bar():
	run_progressbar.visible = false
	run_progressbar.value = 0

func _on_run_timer_timeout() -> void:
	if is_busy:
		return

	is_busy = true
	stop_blocked_effect()
	stop_run_bar()

	var wool_explosion = WOOL_EXPLOSION.instantiate()
	add_child(wool_explosion)
	wool_explosion.global_position = global_position
	wool_explosion.scale *= 10
	wool_explosion.play_explosion()

	var cam := get_viewport().get_camera_2d()
	var screen_size := get_viewport_rect().size
	
	var center := Vector2.ZERO
	if cam:
		center = cam.global_position
	else:
		center = screen_size * 0.5

	var half := screen_size * 0.5

	var side := randi() % 4
	var margin := 100.0
	var target := Vector2.ZERO

	match side:
		0:
			target.x = center.x - half.x - margin
			target.y = randf_range(center.y - half.y, center.y + half.y)
		1:
			target.x = center.x + half.x + margin
			target.y = randf_range(center.y - half.y, center.y + half.y)
		2:
			target.y = center.y - half.y - margin
			target.x = randf_range(center.x - half.x, center.x + half.x)
		3:
			target.y = center.y + half.y + margin
			target.x = randf_range(center.x - half.x, center.x + half.x)

	set_direction(sign(target.x - global_position.x))
	
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.SHEEP_RUN)

	var tween = create_tween()
	tween.tween_property(self, "global_position", target, 2.2)

	await tween.finished
	wool_explosion.queue_free()
	queue_free()

func show_name():
	name_label.visible = true

func hide_name():
	name_label.visible = false
