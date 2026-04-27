extends Control

func _ready() -> void:
	TranslationServer.set_locale("en")

func _on_button_5_pressed() -> void:
	TranslationServer.set_locale("en")


func _on_button_4_pressed() -> void:
	TranslationServer.set_locale("ru")


func _on_play_button_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_settings_button_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished


func _on_exit_button_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()
