extends Entity

var player: Node
@export var tier = 1

func _ready():
	player = get_node("/root/Game/Player")


func _physics_process(delta):
	if global_position.distance_to(player.global_position) > 20:
		direction = (player.global_position - global_position).normalized()
	else: direction = Vector2.ZERO
	if !die:move(delta)
	if closets_enemy != null:
		if can_attack:do_melee_attack()



