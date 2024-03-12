extends CharacterBody2D
class_name Entity

var direction: Vector2
var last_direction:Vector2

@export var max_speed: float
@export var acceleration:float
var current_speed = 0.0

@export var dash_distance:int
var dash_on_cooldown:bool
@export var dash_timer: Timer
@export var dash_cooldown:int = 5



func _ready():
	direction = Vector2.ZERO
	last_direction = direction
	dash_timer.timeout.connect(_on_dash_timer_timeout)

func move(delta):
	print(dash_on_cooldown)
	if direction == Vector2.ZERO:
		current_speed -= acceleration 
		current_speed = clamp(current_speed,0,max_speed)
		velocity = last_direction * (current_speed * delta * 100)
	else:
		last_direction = direction
		current_speed += acceleration
		current_speed = clamp(current_speed,0,max_speed)
		velocity = direction * (current_speed * delta * 100)
	move_and_slide()
	
func do_dash():
	if !dash_on_cooldown:
		if direction != Vector2.ZERO:
			dash_on_cooldown = true
			velocity = last_direction * dash_distance * max_speed
			move_and_slide()
			dash_timer.start(dash_cooldown)
		
func _on_dash_timer_timeout():
	print("aaaaa")
	dash_on_cooldown = false
	


