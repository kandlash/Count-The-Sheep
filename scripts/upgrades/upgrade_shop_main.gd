extends CanvasLayer
@onready var money_label: Label = $UpgradeShop/money_label

func _process(delta: float) -> void:
	money_label.text = str(G.money)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")
