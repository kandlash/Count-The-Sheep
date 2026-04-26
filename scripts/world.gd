extends Node2D
class_name World

@onready var time_progressbar: ProgressBar = $Camera2D/UIHolder/Control/Panel/time_progressbar
@onready var time_label: Label = $Camera2D/UIHolder/Control/Panel/time_progressbar/time_label
@onready var main_light: DirectionalLight2D = $main_light
@onready var sunset_light: DirectionalLight2D = $sunset_light
@onready var jumps_label: Label = $Camera2D/UIHolder/Control/Panel2/jumps_label
@onready var tired_progressbar: ProgressBar = $Camera2D/UIHolder/Control/Panel/tired_progressbar
@onready var tired_label: Label = $Camera2D/UIHolder/Control/Panel/tired_progressbar/tired_label


var jumps_count:= 0
var tired_points:=0
var max_tired_points:=100

const REAL_DURATION := 15.0 * 60.0
const START_TIME_MIN := 22 * 60
const END_TIME_MIN := 5 * 60

var elapsed := 0.0
var total_game_minutes := 0

func _ready() -> void:
	G.world = self
	total_game_minutes = (24 * 60 - START_TIME_MIN) + END_TIME_MIN
	
	time_progressbar.min_value = 0
	time_progressbar.max_value = REAL_DURATION
	time_progressbar.value = 0
	
	# важно для tired bar
	tired_progressbar.min_value = 0
	tired_progressbar.max_value = max_tired_points
	tired_progressbar.value = 0
	tired_label.text = "%d/%d" % [tired_points, max_tired_points]
	

func _process(delta: float) -> void:
	if elapsed >= REAL_DURATION:
		return
	
	elapsed += delta
	time_progressbar.value = elapsed
	
	var t := elapsed / REAL_DURATION
	
	var passed_minutes := int(t * total_game_minutes)
	var current_minutes := START_TIME_MIN + passed_minutes
	
	if current_minutes >= 24 * 60:
		current_minutes -= 24 * 60
	
	var hours := current_minutes / 60
	var minutes := current_minutes % 60
	
	time_label.text = "%02d:%02d" % [hours, minutes]
	
	_update_lighting(current_minutes)

func _update_lighting(current_minutes: int) -> void:
	# === MAIN LIGHT ===
	# пик в 03:00 (180 минут)
	var peak_time := 3 * 60
	
	# расстояние по кругу времени
	var dist_to_peak := _time_distance(current_minutes, peak_time)
	
	# максимальная дистанция (22:00 -> 03:00 = 5 часов = 300 минут)
	var max_dist := 5 * 60
	
	var k = clamp(1.0 - float(dist_to_peak) / max_dist, 0.0, 1.0)
	
	# от 0.5 до 0.8
	main_light.energy = lerp(0.5, 0.8, k)
	
	
	# === SUNSET LIGHT ===
	# с 22:00 до 23:00 плавно гаснет
	var start := 22 * 60
	var end := 23 * 60
	
	if current_minutes >= start and current_minutes <= end:
		var t := float(current_minutes - start) / float(end - start)
		sunset_light.energy = lerp(0.3, 0.0, t)
	else:
		sunset_light.energy = 0.0


func _time_distance(a: int, b: int) -> int:
	var diff = abs(a - b)
	return min(diff, 24 * 60 - diff)
	

func add_jump(jump_points: int, tired_add: int):
	jumps_count += jump_points
	tired_points = clamp(tired_points + tired_add, 0, max_tired_points)
	
	_update_jumps_ui()
	_update_tired_ui_animated()


func _update_jumps_ui() -> void:
	jumps_label.text = str(jumps_count)
	
	var tween := create_tween()
	jumps_label.scale = Vector2(1.25, 1.25)
	tween.tween_property(jumps_label, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)


func _update_tired_ui_animated() -> void:
	# правильный текст: 40/100
	tired_label.text = "%d/%d" % [tired_points, max_tired_points]
	
	var tween := create_tween()
	
	# теперь используем РЕАЛЬНЫЕ значения, не 0..1
	tween.tween_property(tired_progressbar, "value", tired_points, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	# небольшой juice-пульс
	tired_progressbar.scale = Vector2(1.03, 1.03)
	tween.parallel().tween_property(tired_progressbar, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
