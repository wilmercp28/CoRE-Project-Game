extends AnimatedSprite2D

var animation_name = "idle_right"
var entity: Node

func _ready():
	entity = $".."
	

func _physics_process(delta):
	if !entity.die:
		if entity.velocity == Vector2.ZERO:
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
			if entity.direction.y > 0:
				animation_name = "run_down"
			elif entity.direction.y < 0:
				animation_name = "run_up"
			elif entity.direction.x > 0:
				animation_name = "run_right"
			elif entity.direction.x < 0:
				animation_name = "run_left"
		if animation != animation_name:
			animation_update()
	if entity.die and animation != "die":
		animation_name = "die"
		animation_update()
	
func animation_update():
	play(animation_name)
	
	

	
	
	
