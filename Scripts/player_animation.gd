extends AnimatedSprite2D

var animation_name = "idle_right"
var player: Node

func _ready():
	player = $".."
	

func _physics_process(delta):
	if player.velocity == Vector2.ZERO:
		match animation_name:
			"run_up":
				animation_name = "idle_up"
			"run_down":
				animation_name = "idle_down"
			"run_left":
				animation_name = "idle_left"
			"run_right":
				animation_name = "idle_right"
	else:
		if player.direction.y > 0:
			animation_name = "run_down"
		elif player.direction.y < 0:
			animation_name = "run_up"
		elif player.direction.x > 0:
			animation_name = "run_right"
		elif player.direction.x < 0:
			animation_name = "run_left"
	animation_update()
	
	
func animation_update():
	play(animation_name)
	
	

	
	
	
