extends CanvasLayer
signal closed

func _on_close_button_pressed() -> void:
	emit_signal("closed")
	queue_free()
