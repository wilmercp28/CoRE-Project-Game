extends Entity

	
func _physics_process(delta):
	base_damage_multiplayer = 100
	if !die:
		direction = (Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized() * speed) * base_movement_speed_multiplayer
		move()
		if Input.is_action_just_released("ui_accept"):
			do_dash()
		if is_dashing:detect_dash_collision()
		if Input.is_action_pressed("ui_accept"):
			queue_redraw()


