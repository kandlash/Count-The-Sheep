extends Node2D
class_name World

@onready var time_progressbar: ProgressBar = $Camera2D/UIHolder/Control/Panel/time_progressbar
@onready var time_label: Label = $Camera2D/UIHolder/Control/Panel/time_progressbar/time_label
@onready var main_light: DirectionalLight2D = $main_light
@onready var sunset_light: DirectionalLight2D = $sunset_light

const REAL_DURATION := 15.0 * 60.0
const START_TIME_MIN := 22 * 60
const END_TIME_MIN := 5 * 60

var elapsed := 0.0
var total_game_minutes := 0

func _ready() -> void:
	total_game_minutes = (24 * 60 - START_TIME_MIN) + END_TIME_MIN
	
	time_progressbar.min_value = 0
	time_progressbar.max_value = REAL_DURATION
	time_progressbar.value = 0

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
