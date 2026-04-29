extends Node2D
## Audio manager node. Inteded to be globally loaded as a 2D Scene. Handles [method create_2d_audio_at_location()] and [method create_audio()] to handle the playback and culling of simultaneous sound effects.
##
## To properly use, define [enum SoundEffect.SOUND_EFFECT_TYPE] for each unique sound effect, create a Node2D scene for this AudioManager script add those SoundEffect resources to this globally loaded script's [member sound_effects], and setup your individual SoundEffect resources. Then, use [method create_2d_audio_at_location()] and [method create_audio()] to play those sound effects either at a specific location or globally.
## 
## See https://github.com/Aarimous/AudioManager for more information.
##
## @tutorial: https://www.youtube.com/watch?v=Egf2jgET3nQ

var sound_effect_dict: Dictionary = {} ## Loads all registered SoundEffects on ready as a reference.

@export var sound_effects: Array[SoundEffect] ## Stores all possible SoundEffects that can be played.
var sfx_bus_index: int


func _ready() -> void:
	# получаем индекс канала SFX
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect


## Creates a sound effect at a specific location if the limit has not been reached. Pass [param location] for the global position of the audio effect, and [param type] for the SoundEffect to be queued.
func create_2d_audio_at_location(location: Vector2, type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_2D_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_2D_audio)
			new_2D_audio.position = location
			new_2D_audio.stream = sound_effect.sound_effect
			new_2D_audio.volume_db = sound_effect.volume
			new_2D_audio.bus = "Sfx" # ВОТ ЭТО
			new_2D_audio.pitch_scale = sound_effect.pitch_scale
			new_2D_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			new_2D_audio.finished.connect(sound_effect.on_audio_finished)
			new_2D_audio.finished.connect(new_2D_audio.queue_free)
			new_2D_audio.play()


## Creates a sound effect if the limit has not been reached. Pass [param type] for the SoundEffect to be queued.
func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.stream = sound_effect.sound_effect
			new_audio.volume_db = sound_effect.volume
			new_audio.bus = "Sfx" # И ВОТ ЭТО
			new_audio.pitch_scale = sound_effect.pitch_scale
			new_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			new_audio.finished.connect(sound_effect.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()


## Set SFX volume (0.0 - 1.0)
func set_sfx_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(value)
	)


## Get current SFX volume
func get_sfx_volume() -> float:
	var db = AudioServer.get_bus_volume_db(sfx_bus_index)
	return db_to_linear(db)
