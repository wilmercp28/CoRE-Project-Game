extends Projectile

var fire_rate = 5
var speed = 20
var ricochet = 2
var energy_cost = 1
var range = 999999999999999
var player:Node
var energy_bullet: PackedScene = preload("res://Scenes/Projectiles/energy_bullet.tscn")

func _ready():
	player = get_node("/root/Game/Player")
	contact_monitor = true
	max_contacts_reported = 1
	move(Vector2.RIGHT.rotated(rotation) * speed)


func _on_body_entered(body):
	body.apply_damage(20 * player.base_damage_multiplayer)
	if ricochet > 0:
		add_collision_exception_with(body)
		get_next_target(body)
	else:
		queue_free()
	
func get_next_target(last_body):
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest_enemy = null
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < range:
			if closest_enemy == null or distance < global_position.distance_to(closest_enemy.global_position):
				if enemy != last_body:
					closest_enemy = enemy
	if closest_enemy != null:
		var angle = (closest_enemy.global_position - global_position).angle()
		ricochet -= 1
		rotation = angle
	else:
		queue_free() 
	
	
