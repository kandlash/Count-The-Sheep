@tool
extends TextureButton
class_name UpgradeNode

@export var upgrade_id: String:
	set(value):
		upgrade_id = value
		_update()

@onready var upgrade_name: Label = $upgrade_info/upgrade_name
@onready var upgrade_discription: RichTextLabel = $upgrade_info/upgrade_discription
@onready var upgrade_level: Label = $upgrade_info/upgrade_level
@onready var cost_label: Label = $upgrade_info/cost_label
@onready var upgrade_info: Panel = $upgrade_info

var manager: UpgradeManager

# --------------------------------------------------
# READY
# --------------------------------------------------

func _ready():
	if not Engine.is_editor_hint():
		
		manager = upgrade_manager
		if manager:
			manager.changed.connect(_update)

	call_deferred("_update")
	
	if upgrade_info:
		upgrade_info.visible = Engine.is_editor_hint()

# --------------------------------------------------
# SAFE NODE INIT (ВАЖНО ДЛЯ @tool)
# --------------------------------------------------

func _ensure_nodes():
	if upgrade_name == null:
		upgrade_name = get_node_or_null("upgrade_info/upgrade_name")
	if upgrade_discription == null:
		upgrade_discription = get_node_or_null("upgrade_info/upgrade_discription")
	if upgrade_level == null:
		upgrade_level = get_node_or_null("upgrade_info/upgrade_level")
	if cost_label == null:
		cost_label = get_node_or_null("upgrade_info/cost_label")
	if upgrade_info == null:
		upgrade_info = get_node_or_null("upgrade_info")

# --------------------------------------------------
# INPUT
# --------------------------------------------------

func _pressed():
	if Engine.is_editor_hint():
		return
	
	if manager:
		manager.buy(upgrade_id)
		_update()

# --------------------------------------------------
# UPDATE
# --------------------------------------------------

func _update():
	# защита от раннего вызова
	if not is_inside_tree():
		return
	
	_ensure_nodes()

	# если UI ещё не готов — выходим
	if upgrade_name == null:
		return

	if upgrade_id == "":
		return

	var data = UpgradeData.get_data().get(upgrade_id)
	if data == null:
		return

	# -------------------------
	# EDITOR MODE
	# -------------------------
	if Engine.is_editor_hint():
		upgrade_name.text = data.get("name", "NoName")
		upgrade_level.text = "1/%d" % data.get("max_level", 1)

		var costs = data.get("cost", [])
		if costs.size() > 0:
			cost_label.text = str(costs[0])
		else:
			cost_label.text = "0"

		return

	# -------------------------
	# GAME MODE
	# -------------------------
	if manager == null:
		return

	visible = manager.is_unlocked(upgrade_id)
	if !visible:
		return

	var lvl = manager.get_level(upgrade_id)

	upgrade_name.text = data["name"]
	upgrade_level.text = "%d/%d" % [lvl, data["max_level"]]

	if lvl - 1 < data["cost"].size():
		cost_label.text = str(data["cost"][lvl - 1])
	else:
		cost_label.text = "MAX"

	disabled = !manager.can_buy(upgrade_id)

# --------------------------------------------------
# HOVER
# --------------------------------------------------

func _on_mouse_entered() -> void:
	if Engine.is_editor_hint():
		return
	if upgrade_info:
		upgrade_info.visible = true

func _on_mouse_exited() -> void:
	if Engine.is_editor_hint():
		return
	if upgrade_info:
		upgrade_info.visible = false
