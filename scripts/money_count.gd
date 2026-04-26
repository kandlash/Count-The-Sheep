extends CanvasLayer
class_name MoneyCount

@onready var jump_container: HBoxContainer = $Control/Panel2/VBoxContainer/jump_container
@onready var comon_container: HBoxContainer = $Control/Panel2/VBoxContainer/comon_container
@onready var uncomon_container: HBoxContainer = $Control/Panel2/VBoxContainer/uncomon_container
@onready var rare_container: HBoxContainer = $Control/Panel2/VBoxContainer/rare_container
@onready var epic_container: HBoxContainer = $Control/Panel2/VBoxContainer/epic_container
@onready var legendary_container: HBoxContainer = $Control/Panel2/VBoxContainer/legendary_container
@onready var result_container: HBoxContainer = $Control/Panel2/result_container

@onready var jump_label: Label = $Control/Panel2/VBoxContainer/jump_container/jump_label
@onready var common_label: Label = $Control/Panel2/VBoxContainer/comon_container/common_label
@onready var uncomon_label: Label = $Control/Panel2/VBoxContainer/uncomon_container/uncomon_label
@onready var rare_label: Label = $Control/Panel2/VBoxContainer/rare_container/rare_label
@onready var epic_label: Label = $Control/Panel2/VBoxContainer/epic_container/epic_label
@onready var legendary_label: Label = $Control/Panel2/VBoxContainer/legendary_container/legendary_label
@onready var result_label: Label = $Control/Panel2/result_container/result_label

# 💰 награды
var rewards := {
	G.Rarity.COMMON: 1,
	G.Rarity.UNCOMMON: 2,
	G.Rarity.RARE: 5,
	G.Rarity.EPIC: 15,
	G.Rarity.LEGENDARY: 50
}

var jump_reward := 1

# --------------------------------------------------

func _ready():
	_hide_all()
	await start_count()

# --------------------------------------------------

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/upgrade_shop.tscn")


func _hide_all():
	comon_container.visible = false
	uncomon_container.visible = false
	rare_container.visible = false
	epic_container.visible = false
	legendary_container.visible = false
	result_container.visible = false
	jump_container.visible = false

# --------------------------------------------------

func start_count():
	var total_money := 0

	# =========================
	# 💥 JUMPS FIRST
	# =========================

	var jump_money = G.jumps_count * jump_reward

	jump_container.visible = true
	jump_container.modulate.a = 0.0

	var jtween = create_tween()
	jtween.tween_property(jump_container, "modulate:a", 1.0, 0.2)
	jtween.tween_property(jump_container, "scale", Vector2(1.05, 1.05), 0.1)
	jtween.tween_property(jump_container, "scale", Vector2.ONE, 0.1)

	await jtween.finished

	await _animate_number(jump_label, 0, jump_money)

	total_money += jump_money

	await get_tree().create_timer(0.15).timeout

	# =========================
	# 🐑 RARITIES
	# =========================

	total_money += await _show_line(comon_container, common_label, G.Rarity.COMMON)
	total_money += await _show_line(uncomon_container, uncomon_label, G.Rarity.UNCOMMON)
	total_money += await _show_line(rare_container, rare_label, G.Rarity.RARE)
	total_money += await _show_line(epic_container, epic_label, G.Rarity.EPIC)
	total_money += await _show_line(legendary_container, legendary_label, G.Rarity.LEGENDARY)

	# =========================
	# 💰 RESULT
	# =========================

	await get_tree().create_timer(0.2).timeout

	await _show_result(total_money)

	G.money += total_money

	# очистка (важно)
	for k in G.rarity_counts.keys():
		G.rarity_counts[k] = 0

# --------------------------------------------------
# 🧮 LINE
# --------------------------------------------------

func _show_line(container: Control, label: Label, rarity: int) -> int:
	var count = G.rarity_counts[rarity]

	if count <= 0:
		return 0

	container.visible = true
	container.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(container, "modulate:a", 1.0, 0.2)
	tween.tween_property(container, "scale", Vector2(1.05, 1.05), 0.1)
	tween.tween_property(container, "scale", Vector2.ONE, 0.1)

	await tween.finished

	var money = count * rewards[rarity]

	await _animate_number(label, 0, money)

	await get_tree().create_timer(0.1).timeout

	return money

# --------------------------------------------------
# 🔢 NUMBER ANIMATION
# --------------------------------------------------

func _animate_number(label: Label, from: int, to: int):
	var duration := 0.5

	var tween = create_tween()
	tween.tween_method(
		func(value):
			label.text = str(int(value)),
		from,
		to,
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	await tween.finished

# --------------------------------------------------
# 💰 RESULT
# --------------------------------------------------

func _show_result(total: int):
	result_container.visible = true
	result_container.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(result_container, "modulate:a", 1.0, 0.25)
	tween.tween_property(result_container, "scale", Vector2(1.1, 1.1), 0.15)
	tween.tween_property(result_container, "scale", Vector2.ONE, 0.15)

	await tween.finished

	await _animate_number(result_label, 0, total)
