extends Entity

	
func _physics_process(delta):
	if !die:
		direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
		move(delta)
		if Input.get_action_strength("ui_accept"):
			do_dash()
		if Input.get_action_strength("ui_select"):
			apply_damage(10)
	
