extends Node2D
const WOOL_EXPLOSION = preload("uid://c1clqw5ixuui1")
const GROUND_PARTICLE = preload("uid://dm25grvgcife6")

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		_handle_click(get_global_mouse_position())


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
