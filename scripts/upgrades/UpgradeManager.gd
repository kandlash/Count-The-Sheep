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
	
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
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

		"lucky":
			G.apply_lucky(effect["value"])
		
		"sheep_speed_percent":
			G.sheep_walk_speed -= G.sheep_walk_speed * effect["value"] / 100
			
		"spawn_dog":
			G.dogs_to_spawn += effect["value"]
			
		"sheep_max_time":
			G.sheep_spawn_delay_min -= G.sheep_spawn_delay_min * effect["value"]/100
			G.sheep_spawn_delay_max -= G.sheep_spawn_delay_max * effect["value"]/100
		"dogs_speed_percent":
			G.dogs_speed += G.dogs_speed * effect["value"]/100
		"sheep_confusion_time":
			G.sheep_run_timer += G.sheep_run_timer * effect["value"]/100
		"uncomon_bonuses":
			G.reward_multipliers[G.Rarity.UNCOMMON] += effect["value"] / 100.0

		"rare_bonuses":
			G.reward_multipliers[G.Rarity.RARE] += effect["value"] / 100.0

		"epic_bonuses":
			G.reward_multipliers[G.Rarity.EPIC] += effect["value"] / 100.0

		"legend_bonuses":
			G.reward_multipliers[G.Rarity.LEGENDARY] += effect["value"] / 100.0
		_:
			push_warning("Unknown effect: " + str(effect))

func is_unlocked(id: String) -> bool:
	var cfg = data[id]

	# если нет родителей — доступен сразу
	if !cfg.has("parents") or cfg["parents"].is_empty():
		return true

	# 🔥 ВСЕ родители должны быть замакшены
	for p in cfg["parents"]:
		var parent_lvl = get_level(p)
		var parent_max = data[p]["max_level"]

		if parent_lvl < parent_max:
			return false

	return true

func _spawn_dog(amount: int):
	if G.world == null:
		push_warning("World is null, cannot spawn dog")
		return

	for i in amount:
		G.world.add_dog()
