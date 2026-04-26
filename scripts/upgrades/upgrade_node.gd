extends Button
class_name UpgradeNode

@export var upgrade_id: String

@onready var manager: UpgradeManager = upgrade_manager

func _ready():
	manager.changed.connect(_update)
	call_deferred("_update")

func _pressed():
	manager.buy(upgrade_id)
	_update()

func _update():
	var data = UpgradeData.get_data().get(upgrade_id)
	if data == null:
		return

	visible = manager.is_unlocked(upgrade_id)
	if !visible:
		return

	var lvl = manager.get_level(upgrade_id)

	text = "%s\nLv %d/%d" % [
		data["name"],
		lvl,
		data["max_level"]
	]

	disabled = !manager.can_buy(upgrade_id)
