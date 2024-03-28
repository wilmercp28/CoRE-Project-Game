extends RigidBody2D
class_name Entity

@export var devMode = false
#Attributes
@export var target_group: String
@export var health: int
var max_health: int
var die = false
var base_damage_multiplayer = 10.0
var base_fire_rate_multiplayer = 1.0
var base_movement_speed_multiplayer = 1.0
var damage_reduction = 0.0
var base_attack_rate_multiplayer = 1.0
@export var hit_box:Area2D
@export var range:Area2D

 #Directions
var direction: Vector2
var last_direction:Vector2

#Movement

@export var speed: float
@export var path_finding: bool = true
@export var recalculation_delay: float = 0.5
var nav_agent: NavigationAgent2D
var pathing_calculation_timer:Timer

# Dash
@export var dash_speed_multiplayer:int
var dash_on_cooldown:bool
var dash_timer: Timer
@export var dash_duration:float = 0.1
@export var dash_cooldown:int = 5
var is_dashing = false
var dash_collisions = []

# UI Component
@export var health_bar: ProgressBar
@export var health_label:Label
@export var entity_sprite:AnimatedSprite2D

# Enemy Damaging/Targeting
var enemies_inside_range = []
var closets_enemy = null
var attack_timer: Timer
var can_attack = true

#PreLoads
var dash_smoke = preload("res://Scenes/Effects/Smoke.tscn")
var dash_smoke2 = preload("res://Scenes/Effects/smoke_2.tscn")

func _init():
	linear_damp = 5
	direction = Vector2.ZERO
	last_direction = direction
	connect_signals()
func _ready():
	max_health = health
	
func connect_signals():
	dash_timer = Timer.new()
	attack_timer = Timer.new()
	attack_timer.one_shot = true
	dash_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	if path_finding:
		pathing_calculation_timer = Timer.new()
		pathing_calculation_timer.autostart = true
		pathing_calculation_timer.wait_time = recalculation_delay
		pathing_calculation_timer.timeout.connect(_recalculate_path)
		nav_agent = NavigationAgent2D.new()
		nav_agent.debug_enabled = devMode
		nav_agent.max_speed = (mass * speed) * base_movement_speed_multiplayer
		nav_agent.target_desired_distance = 20
		nav_agent.path_postprocessing = 1
		nav_agent.path_desired_distance = 60
		nav_agent.avoidance_enabled = true
		nav_agent.velocity_computed.connect(_on_path_computed)
		add_child(pathing_calculation_timer)
		add_child(nav_agent)
	add_child(dash_timer)
	add_child(attack_timer)
	
func move():
	if direction != Vector2.ZERO:
		apply_central_force(direction * mass)
	else:
		last_direction = direction
	if is_dashing:detect_dash_collision()
	
func _on_path_computed(safe_velocity:Vector2):
	direction = safe_velocity
	
func _recalculate_path():
	nav_agent.max_speed = speed * base_movement_speed_multiplayer
	var player = get_node("/root/Game/Player")
	nav_agent.target_position = player.global_position + (player.direction / 2)
	if global_position.distance_to(get_node("/root/Game/Player").global_position) < 30:
		nav_agent.avoidance_enabled = false
	else:
		nav_agent.avoidance_enabled = true
	direction = (nav_agent.get_next_path_position() - global_position).normalized()
	nav_agent.velocity = (direction * speed) * base_movement_speed_multiplayer
	if nav_agent.avoidance_enabled:
		nav_agent.velocity = (direction * speed) * base_movement_speed_multiplayer
	else:
		_on_path_computed((direction * speed) * base_movement_speed_multiplayer)
			
func detect_dash_collision():
	var collisions = hit_box.get_overlapping_bodies()
	for body in collisions:
		if body.is_in_group(target_group) and !body in dash_collisions:
			dash_collisions.append(body)
	
func do_dash():
	if !dash_on_cooldown and !is_dashing:
		if direction != Vector2.ZERO:
			is_dashing = true
			collision_layer = 2
			collision_mask = 2
			var smoke = dash_smoke.instantiate()
			smoke.global_position = global_position - direction * 50
			smoke.rotation = direction.angle() + PI / 2
			add_child(smoke)
			dash_timer.start(dash_duration)
			apply_central_impulse((direction * mass * dash_speed_multiplayer) * base_movement_speed_multiplayer)
			
func _on_dash_timer_timeout():
	if is_dashing:
		collision_layer = 1
		collision_mask = 1
		is_dashing = false
		for body in dash_collisions:
			body.apply_damage(5 * base_damage_multiplayer)
		dash_collisions.clear()
		dash_on_cooldown = true
		dash_timer.start(dash_cooldown)
	else:
		dash_on_cooldown = false
	
func update_health_UI():
	if health_bar != null:
		health_bar.value
		health_bar.max_value = max_health
	if health_label != null:
		health_label.text = str(health) + " / " + str(max_health)

func apply_damage(amount):
	if damage_reduction > 0.8: damage_reduction = 0.8
	var damage = amount * (1 - damage_reduction)
	if devMode:damage = 0
	if health > damage:
		health -= damage
		update_health_UI()
		var tween = get_tree().create_tween()
		tween.tween_property(self,"modulate:",Color.RED,0.05)
		tween.tween_property(self,"modulate:",Color(1,1,1,1),0.05)
	else:
		health -= damage
		die = true
		remove_entity()
		
func regenerate_health(amount):
	if max_health < health + amount:
		health = max_health
	else:
		health += amount
		
func remove_entity():
	var tween = get_tree().create_tween()
	tween.tween_callback(queue_free).set_delay(2)
	
func check_for_enemies():
	var enemies = range.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.is_in_group(target_group):
			enemies_inside_range.append(enemy)
	closets_enemy = get_closest_enemy()
	enemies_inside_range = []

func get_closest_enemy():
	if enemies_inside_range.is_empty():
		return null
	else:
		for enemy in enemies_inside_range:
			closets_enemy = enemies_inside_range[0]
			var enemy_distance = global_position.distance_to(enemy.global_position)
			var closest_enemy_distance = global_position.distance_to(closets_enemy.global_position)
			if enemy_distance < closest_enemy_distance:
				closets_enemy = enemy
		return closets_enemy

func do_melee_attack():
	closets_enemy.apply_damage(1 * base_damage_multiplayer)
	can_attack = false
	attack_timer.start(1 / base_attack_rate_multiplayer)
	
func _on_attack_timer_timeout():
	can_attack = true
	
	
		
	
	
	
	


