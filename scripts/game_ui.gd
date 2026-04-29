extends Control

const SETTINGS = preload("uid://c7ab6n4n3jkph")
@onready var setting_button: Button = $setting_button

func _on_setting_button_pressed() -> void:
	var settings = SETTINGS.instantiate()
	settings.connect("closed", _on_settings_closed)
	setting_button.disabled = true
	add_child(settings)

func _on_settings_closed():
	setting_button.disabled = false
