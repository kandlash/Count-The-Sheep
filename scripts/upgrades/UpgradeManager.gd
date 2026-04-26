extends Node
class_name UpgradeManager

signal changed

var data = UpgradeData.get_data()

func get_level(id: String) -> int:
	return G.upgrades.get(id, 0)

func can_buy(id: String) -> bool:
	if !is_unlocked(id):
		return false

	var lvl = get_level(id)
	var cfg = data[id]

	if lvl >= cfg["max_level"]:
		return false

	return G.money >= cfg["cost"][lvl]

func buy(id: String):
	if !can_buy(id):
		return

	var lvl = get_level(id)
	var cfg = data[id]

	G.money -= cfg["cost"][lvl]
	lvl += 1
	G.upgrades[id] = lvl

	_apply_effects(id, lvl)

	emit_signal("changed")

# 🔥 НОВАЯ СИСТЕМА ЭФФЕКТОВ
func _apply_effects(id: String, lvl: int):
	var cfg = data[id]

	# берём эффекты для конкретного уровня
	var effects_list = cfg["effects"][lvl - 1]

	for effect in effects_list:
		_apply_single_effect(effect)

func _apply_single_effect(effect: Dictionary):
	match effect["type"]:

		"max_tired":
			G.max_tired_points = effect["value"]

		"jump_power":
			G.jump_power = effect["value"]

		"income_multiplier":
			G.income_multiplier = effect["value"]

		# 🆕 LUCKY
		"lucky":
			G.apply_lucky(effect["value"])
		
		_:
			push_warning("Unknown effect: " + str(effect))

func is_unlocked(id: String) -> bool:
	var cfg = data[id]

	if !cfg.has("parents") or cfg["parents"].is_empty():
		return true

	for p in cfg["parents"]:
		if G.upgrades.get(p, 0) > 0:
			return true

	return false
