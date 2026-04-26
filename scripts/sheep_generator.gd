extends Node2D
class_name SheepGenerator

const SHEEP = preload("uid://mkci2tl1k4fs")

enum SheepDirection {
	LEFT,
	RIGHT
}

@export var direction: SheepDirection = SheepDirection.LEFT
@export var spawn_delay_min := 1.0
@export var spawn_delay_max := 3.0

var timer: Timer


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_spawn_sheep)
	
	_start_timer(1.0, 3.0)


func _start_timer(sdmin: float = spawn_delay_min, sdmax: float = spawn_delay_max):
	timer.wait_time = randf_range(sdmin, sdmax)
	timer.start()


func _spawn_sheep():
	var sheep = SHEEP.instantiate()
	get_parent().add_child(sheep)
	
	sheep.global_position = global_position
	
	# направление
	var dir = -1 if direction == SheepDirection.LEFT else 1
	
	sheep.set_direction(dir)
	
	_start_timer()
