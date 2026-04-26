extends Node

var tired_points := 0
var jumps_count := 0

var max_tired_points := 100
var money := 0

var jump_power := 1.0
var income_multiplier := 1.0

var upgrades := {} # id -> level

var world: World

# =========================
# 🐑 РЕДКОСТИ (ЕДИНЫЙ ИСТОЧНИК)
# =========================

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

var sheep_base_chances := {
	Rarity.COMMON: 90.0,
	Rarity.UNCOMMON: 4.0,
	Rarity.RARE: 3.0,
	Rarity.EPIC: 2.0,
	Rarity.LEGENDARY: 1.0
}

var rarity_counts := {
	Rarity.COMMON: 0,
	Rarity.UNCOMMON: 0,
	Rarity.RARE: 0,
	Rarity.EPIC: 0,
	Rarity.LEGENDARY: 0
}

var sheep_chances := sheep_base_chances.duplicate()

# =========================
# 🍀 LUCKY
# =========================

func apply_lucky(power: float):
	sheep_chances = sheep_base_chances.duplicate()

	sheep_chances[Rarity.COMMON] *= (1.0 - power)

	sheep_chances[Rarity.UNCOMMON] *= (1.0 + power * 0.5)
	sheep_chances[Rarity.RARE] *= (1.0 + power)
	sheep_chances[Rarity.EPIC] *= (1.0 + power * 1.5)
	sheep_chances[Rarity.LEGENDARY] *= (1.0 + power * 2.0)

	_normalize_sheep_chances()

func add_rarity(rarity: int):
	if rarity_counts.has(rarity):
		rarity_counts[rarity] += 1

func _normalize_sheep_chances():
	var total := 0.0
	for v in sheep_chances.values():
		total += v

	if total <= 0.0:
		return

	for k in sheep_chances.keys():
		sheep_chances[k] = (sheep_chances[k] / total) * 100.0
