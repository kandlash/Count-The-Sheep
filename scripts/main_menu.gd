extends Control
const SETTINGS = preload("uid://c7ab6n4n3jkph")

func _ready() -> void:
	MusicManager.play_random_track()
	TranslationServer.set_locale("en")

func _on_button_5_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
	TranslationServer.set_locale("en")


func _on_button_4_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
	TranslationServer.set_locale("ru")


func _on_play_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_settings_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
	var settings = SETTINGS.instantiate()
	add_child(settings)


func _on_exit_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()
