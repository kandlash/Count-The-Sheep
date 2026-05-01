extends Node

@export var tracks: Array[AudioStream]
@export var fade_time: float = 2.0
@export var history_size: int = 3

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
var history: Array[int] = []  # храним индексы треков
var default_volume_db
func _ready():
	default_volume_db = player.volume_db

func play_random_track():
	if tracks.is_empty():
		return
	
	var index = get_random_track_index()
	var track = tracks[index]

	# обновляем историю
	history.append(index)
	if history.size() > history_size:
		history.pop_front()

	player.stream = track
	player.volume_db = -80
	player.play()

	await fade_in()

	# ждём почти конец
	await get_tree().create_timer(player.stream.get_length() - fade_time).timeout
	
	await fade_out()
	play_random_track()


func get_random_track_index() -> int:
	var available := []

	for i in tracks.size():
		if i not in history:
			available.append(i)

	# если вдруг треков мало и всё попало в историю
	if available.is_empty():
		available = range(tracks.size())

	return available.pick_random()


func fade_in():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", default_volume_db, fade_time)
	await tween.finished


func fade_out():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, fade_time)
	await tween.finished
	player.stop()
