extends Control

@onready var money_label: Label = $CanvasLayer/Panel4/HBoxContainer/money_label
@onready var content: Node2D = $GraphRoot


var dragging := false
var last_mouse_pos := Vector2.ZERO

var zoom := 0.2
@export var zoom_min := 0.1
@export var zoom_max := 3.5
@export var zoom_speed := 0.1

func _ready():
	content.scale = Vector2.ONE * zoom
	


	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func _input(event):
	# -----------------------
	# DRAG (ЛКМ)
	# -----------------------
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_mouse_pos = event.position

		# -----------------------
		# ZOOM (колесо)
		# -----------------------
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_apply_zoom(1.0 + zoom_speed, event.position)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_apply_zoom(1.0 - zoom_speed, event.position)

	# -----------------------
	# MOVE
	# -----------------------
	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		last_mouse_pos = event.position

		content.position += delta

func _process(delta: float) -> void:
	money_label.text = str(G.money)

func _apply_zoom(factor: float, mouse_pos: Vector2):
	var new_zoom = clamp(zoom * factor, zoom_min, zoom_max)
	var zoom_ratio = new_zoom / zoom

	# позиция до зума
	var before = (mouse_pos - content.position) / zoom

	zoom = new_zoom
	content.scale = Vector2.ONE * zoom

	# позиция после зума
	var after = before * zoom

	# компенсируем смещение (чтобы зум был к курсору)
	content.position += (mouse_pos - (content.position + after))
