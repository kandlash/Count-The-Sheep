extends Node2D

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		_handle_click(event.position)


func _handle_click(pos: Vector2):
	var space = get_viewport().get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result = space.intersect_point(query, 32)
	if result.is_empty():
		return

	# берем ПЕРВУЮ подходящую овцу
	for hit in result:
		var obj = hit.collider
		if obj.is_in_group("sheep"):
			print('sheep click - ', obj.get_parent())
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHEEP_CLICK)
			obj.get_parent().click_animation()
			obj.get_parent().request_jump()
			return
