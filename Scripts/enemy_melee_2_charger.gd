extends Entity

var player: Node
@export var tier = 1
var preparing_dash = false
@export var distance_for_performance_dash = 100

func _ready():
	player = get_node("/root/Game/Player")


func _physics_process(delta):
	move()
	if closets_enemy != null:
		if can_attack:do_melee_attack()

func perform_dash():
	preparing_dash = false
	direction = (player.global_position - global_position).normalized()
	do_dash()
