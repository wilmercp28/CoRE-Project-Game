extends Projectile

var fire_rate = 1
var speed = 20
var ricochet = 0
var energy_cost = 1
var range = 100
var player:Node
func _ready():
	player = get_node("/root/Game/Player")
	contact_monitor = true
	max_contacts_reported = 1

func _physics_process(delta):
	move(Vector2.RIGHT.rotated(rotation) * speed)

func _on_body_entered(body):
	body.apply_damage(20 * player.base_damage_multiplayer)
