extends CharacterBody2D
class_name Entity


#Attributes
@export var health: int
var max_health: int
var die = false
var base_fire_rate_multiplayer = 1.0
var base_movement_speed_multiplayer = 1.0
var base_dash_distance_multiplayer = 1.0
var damage_reduction = 0.0

 #Directions
var direction: Vector2
var last_direction:Vector2

#Movement
@export var max_speed: float
@export var acceleration:float
var current_speed = 0.0

# Dash
@export var dash_distance:int
var dash_on_cooldown:bool
@export var dash_timer: Timer
@export var dash_cooldown:int = 5
var dash_trail:Line2D
var tween: Tween
var is_dashing = false

# UI Component
@export var health_bar: ProgressBar
@export var health_label:Label

#PreLoads
var dash_smoke = preload("res://Scenes/Effects/Smoke.tscn")
var dash_smoke2 = preload("res://Scenes/Effects/smoke_2.tscn")

func _ready():
	max_health = health
	direction = Vector2.ZERO
	last_direction = direction
	dash_timer = Timer.new()
	add_child(dash_timer)
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	
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
			var smoke = dash_smoke.instantiate()
			var target_position = global_position + direction * dash_distance
			smoke.global_position = global_position
			smoke.rotation = (target_position - global_position).angle() + PI / 2
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", target_position, 0.2)
			get_parent().add_child(smoke)
			dash_timer.start(dash_cooldown)
			
func _on_dash_timer_timeout():
	dash_on_cooldown = false

func apply_damage(amount):
	pass
	
	


