extends Node2D
const WOOL_EXPLOSION = preload("uid://c1clqw5ixuui1")
const GROUND_PARTICLE = preload("uid://dm25grvgcife6")
var hovered_sheep: Node = null

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		_handle_click(get_global_mouse_position())

func _process(delta: float) -> void:
	_handle_hover()

func _handle_hover():
	var space = get_viewport().get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = []

	var result = space.intersect_point(query, 16)

	var new_hovered = null

	for hit in result:
		var obj = hit.collider
		if obj.is_in_group("sheep"):
			new_hovered = obj.get_parent() # если collider внутри овцы
			break

	# если ничего не нашли — скрываем
	if new_hovered == null:
		_clear_hover()
		return

	# если та же овца — ничего не делаем
	if new_hovered == hovered_sheep:
		return

	# переключение hover
	_set_hover(new_hovered)

func _set_hover(sheep):
	_clear_hover()

	hovered_sheep = sheep

	if hovered_sheep.has_method("show_name"):
		hovered_sheep.show_name()
	else:
		hovered_sheep.name_label.visible = true


func _clear_hover():
	if hovered_sheep == null:
		return

	if is_instance_valid(hovered_sheep):
		if hovered_sheep.has_method("hide_name"):
			hovered_sheep.hide_name()
		else:
			hovered_sheep.name_label.visible = false

	hovered_sheep = null

func _handle_click(pos: Vector2):
	var space = get_viewport().get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result = space.intersect_point(query, 16)
	if result.is_empty():
		var click_effect = GROUND_PARTICLE.instantiate()
		add_child(click_effect)
		click_effect.global_position = pos
		click_effect.emitting = true
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
		return

	for hit in result:
		var obj = hit.collider
		if obj.is_in_group("sheep"):
			var click_effect = WOOL_EXPLOSION.instantiate()
			add_child(click_effect)
			click_effect.global_position = obj.global_position
			click_effect.play_explosion()
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
			obj.get_parent().click_animation()
			obj.get_parent().request_jump()
			await get_tree().create_timer(0.5).timeout
			click_effect.queue_free()
		if obj.is_in_group("dogs"):
			obj.get_parent().on_click()
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
