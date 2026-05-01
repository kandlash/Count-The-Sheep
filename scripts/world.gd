extends Node2D
class_name World

@onready var time_progressbar: ProgressBar = $Camera2D/UIHolder/gameUI/Panel/time_progressbar
@onready var time_label: Label = $Camera2D/UIHolder/gameUI/Panel/time_progressbar/time_label
@onready var main_light: DirectionalLight2D = $main_light
@onready var sunset_light: DirectionalLight2D = $sunset_light
@onready var jumps_label: Label = $Camera2D/UIHolder/gameUI/Panel2/HBoxContainer/jumps_label
@onready var tired_progressbar: ProgressBar = $Camera2D/UIHolder/gameUI/Panel/tired_progressbar
@onready var tired_label: Label = $Camera2D/UIHolder/gameUI/Panel/tired_progressbar/tired_label
@onready var cursor_light: PointLight2D = $cursor_light

#@onready var common_label: Label = $Camera2D/UIHolder/gameUI/Panel2/VBoxContainer/HBoxContainer/common_label
#@onready var uncommon_label: Label = $Camera2D/UIHolder/gameUI/Panel2/VBoxContainer/HBoxContainer2/uncommon_label
#@onready var rare_label: Label = $Camera2D/UIHolder/gameUI/Panel2/VBoxContainer/HBoxContainer3/rare_label
#@onready var epic_label: Label = $Camera2D/UIHolder/gameUI/Panel2/VBoxContainer/HBoxContainer4/epic_label
#@onready var legendary_label: Label = $Camera2D/UIHolder/gameUI/Panel2/VBoxContainer/HBoxContainer5/legendary_label

@export var dog_scene: PackedScene


const REAL_DURATION := 3.0 * 60.0 # ночь
var elapsed := 0.0

var dogs := []


func _sync_dogs_from_g():
	if G.dogs_to_spawn <= 0:
		return

	for i in G.dogs_to_spawn:
		_spawn_dog()



func _spawn_dog():
	var dog = dog_scene.instantiate()
	add_child(dog)
	dogs.append(dog)


func _ready() -> void:
	cursor_light.enabled = false
	G.world = self
	_sync_dogs_from_g()
	time_progressbar.min_value = 0
	time_progressbar.max_value = REAL_DURATION
	time_progressbar.value = 0

	# tired теперь тоже countdown
	tired_progressbar.min_value = 0
	tired_progressbar.max_value = G.max_tired_points
	tired_progressbar.value = G.tired_points

	_update_tired_ui()
	_update_jumps_ui()
	_update_rarity_ui()

var legendary_event_started := false

func _process(delta: float) -> void:
	if elapsed >= REAL_DURATION:
		_update_tired(delta)
		if !legendary_event_started:
			_start_legendary_event()
		return

	elapsed += delta
	time_progressbar.value = elapsed

	_update_time()
	_update_tired(delta)


var normal_delay_min
var normal_delay_max
func _start_legendary_event():
	legendary_event_started = true

	print("LEGENDARY EVENT STARTED")
	$Camera2D/UIHolder/gameUI/legendary_run_label.visible = true
	# делаем 100% шанс легендарных
	for k in G.sheep_chances.keys():
		G.sheep_chances[k] = 0.0
	
	normal_delay_min = G.sheep_spawn_delay_min
	normal_delay_max = G.sheep_spawn_delay_max
	G.sheep_chances[G.Rarity.LEGENDARY] = 100.0
	G.sheep_spawn_delay_min = 1.0
	G.sheep_spawn_delay_max = 3.0
	await get_tree().create_timer(3.0).timeout
	$Camera2D/UIHolder/gameUI/legendary_run_label.visible = false

# ---------------- TIME ----------------

func _update_time():
	var remaining := REAL_DURATION - elapsed
	remaining = max(remaining, 0.0)

	var total_sec := int(remaining)
	var minutes := total_sec / 60
	var seconds := total_sec % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

	_update_lighting()


# ---------------- LIGHT ----------------

func _update_lighting() -> void:
	var t := elapsed / REAL_DURATION

	var peak := 0.7
	var dist = abs(t - peak)
	var k = clamp(1.0 - dist / peak, 0.0, 1.0)

	main_light.energy = lerp(0.5, 0.8, k)

	if t <= 0.15:
		var sunset_t := t / 0.15
		sunset_light.energy = lerp(0.3, 0.0, sunset_t)
	else:
		sunset_light.energy = 0.0
		
	var night_start := 0.1

	if t >= night_start:
		var night_t := (t - night_start) / (1.0 - night_start)/2
		cursor_light.enabled = true
		cursor_light.energy = lerp(0.0, 2.2, night_t)
	else:
		cursor_light.energy = 0.0
		cursor_light.enabled = false


# ---------------- TIRED (COUNTDOWN) ----------------

func _update_tired(delta: float) -> void:
	G.tired_points += delta
	G.tired_points = min(G.tired_points, G.max_tired_points)

	_update_tired_ui_animated()

	if G.tired_points >= G.max_tired_points:
		_on_exhausted()


func _on_exhausted():
	G.tired_points = 0
	if legendary_event_started:
		G.sheep_chances = G.sheep_base_chances.duplicate()
		G.sheep_spawn_delay_min = normal_delay_min
		G.sheep_spawn_delay_max = normal_delay_max
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/money_count.tscn")


# ---------------- GAMEPLAY ----------------

func add_jump(jump_points: int, _tired_add: int, rarity: int):
	G.jumps_count += jump_points
	G.add_rarity(rarity)

	_update_jumps_ui()
	_update_rarity_ui()


# ---------------- UI ----------------

func _update_jumps_ui() -> void:
	jumps_label.text = str(G.jumps_count)

	var tween := create_tween()
	jumps_label.scale = Vector2(1.25, 1.25)
	tween.tween_property(jumps_label, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)


func _update_tired_ui():
	var remaining := int(G.max_tired_points - G.tired_points)
	remaining = max(remaining, 0)

	tired_label.text = "%02d:%02d" % [remaining / 60, remaining % 60]
	tired_progressbar.value = G.tired_points


func _update_tired_ui_animated() -> void:
	var remaining := int(G.max_tired_points - G.tired_points)
	remaining = max(remaining, 0)

	tired_label.text = "%02d:%02d" % [remaining / 60, remaining % 60]

	var tween := create_tween()
	tween.tween_property(tired_progressbar, "value", G.tired_points, 0.2)\
		.set_trans(Tween.TRANS_LINEAR)


func _update_rarity_ui():
	pass
	#common_label.text = str(G.rarity_counts[G.Rarity.COMMON])
	#uncommon_label.text = str(G.rarity_counts[G.Rarity.UNCOMMON])
	#rare_label.text = str(G.rarity_counts[G.Rarity.RARE])
	#epic_label.text = str(G.rarity_counts[G.Rarity.EPIC])
	#legendary_label.text = str(G.rarity_counts[G.Rarity.LEGENDARY])
