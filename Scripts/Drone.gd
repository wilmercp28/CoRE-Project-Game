extends Sprite2D

var player: Node
var orbitRadius: float = 40
var orbitSpeed: float = 0.5
var angle: float

var range: int = 150
var closest_enemy: Node
var rotation_speed: float = 0.1

var charge = 100
var is_charging = false
var can_shoot = true
var fire_rate_timer: Timer

var is_laser = false


var is_bullets = true
var is_bullet_ricochet = false
var number_of_ricochet = 1
var energy_bullet: PackedScene = preload("res://Scenes/Projectiles/energy_bullet.tscn")

var is_rockets = false

func _ready():
	player = get_node("/root/Game/Player")
	fire_rate_timer = Timer.new()
	fire_rate_timer.one_shot = true
	fire_rate_timer.timeout.connect(_on_fire_rate_timeout)
	add_child(fire_rate_timer)

func _on_fire_rate_timeout():
	can_shoot = true

func _physics_process(delta):
	if charge <= 0 and !is_charging:
		is_charging = true
		drone_charging_start()
	get_closest_enemy()
	if closest_enemy != null:
		var angle_to_enemy = global_position.direction_to(closest_enemy.global_position).angle()
		rotation = rotate_toward(rotation,angle_to_enemy,rotation_speed)
	orbit_player(delta)
	var base_fire_rate_multiplayer = player.base_fire_rate_multiplayer
	if !is_charging:
		if closest_enemy != null:
			if can_shoot:
				if is_bullets:
					shootBullets()
	
func drone_charging_start():
	pass
	
func shootBullets():
	var bullet_instance = energy_bullet.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.rotation = rotation
	get_parent().get_parent().add_child(bullet_instance)
	can_shoot = false
	fire_rate_timer.start(bullet_instance.fire_rate)
	
func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < range:
			if closest_enemy == null or distance < global_position.distance_to(closest_enemy.global_position):
				closest_enemy = enemy
				
func orbit_player(delta):
	angle += delta * orbitSpeed
	var orbitPosition = Vector2(
		cos(angle) * orbitRadius,
		sin(angle) * orbitRadius)
	global_position = player.global_position + orbitPosition
