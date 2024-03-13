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
var dash_trail:Line2D
var tween: Tween
var is_dashing = false


func _ready():
	tween = get_tree().create_tween()
	create_dash_trail()
	direction = Vector2.ZERO
	last_direction = direction
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	
func create_dash_trail():
	dash_trail = Line2D.new()
	dash_trail.antialiased = true
	var width_curve = Curve.new()
	var num_points = 100
	for i in range(num_points):
		var t = i / float(num_points - 1)
		width_curve.add_point(Vector2(t, lerp(0, 1, t)))
	dash_trail.width_curve = width_curve


func move(delta):
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
			var target_position = global_position + direction.normalized() * dash_distance
			dash_trail.add_point(global_position)
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", target_position, 0.2)
			tween.tween_callback(_end_of_dash)
			dash_timer.start(dash_cooldown)
			
func _end_of_dash():
	dash_trail.add_point(global_position)
	get_parent().add_child(dash_trail)
	
	if dash_trail.point_count() > 1:
		dash_trail.remove_point(0)
	
	
		
func _on_dash_timer_timeout():
	dash_on_cooldown = false
	


