extends Entity

	
func _physics_process(delta):
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	move(delta)
	if Input.get_action_strength("ui_accept"):
		do_dash()
		dash_on_cooldown = false
	
