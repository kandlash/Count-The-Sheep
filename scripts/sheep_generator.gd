extends Node2D
class_name SheepGenerator

const SHEEP = preload("uid://mkci2tl1k4fs")

enum SheepDirection {
	LEFT,
	RIGHT
}

var timer: Timer

@export var direction: SheepDirection = SheepDirection.LEFT
@export var spawn_delay_min := 1.0
@export var spawn_delay_max := 3.0

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_spawn_sheep)
	
	_start_timer(2.0, 4.0)

func _start_timer(sdmin: float = spawn_delay_min, sdmax: float = spawn_delay_max):
	timer.wait_time = randf_range(sdmin, sdmax)
	timer.start()

func _spawn_sheep():
	var sheep = SHEEP.instantiate()
	get_parent().add_child(sheep)
	
	sheep.global_position = global_position
	
	var dir = -1 if direction == SheepDirection.LEFT else 1
	sheep.set_direction(dir)

	var rarity = _roll_rarity()
	sheep.set_rarity(rarity)

	_start_timer(G.sheep_spawn_delay_min, G.sheep_spawn_delay_max)

func _roll_rarity() -> int:
	var chances = G.sheep_chances

	var total := 0.0
	for v in chances.values():
		total += v

	var roll := randf() * total
	var acc := 0.0

	for r in chances.keys():
		acc += chances[r]
		if roll <= acc:
			return r

	return G.Rarity.COMMON
