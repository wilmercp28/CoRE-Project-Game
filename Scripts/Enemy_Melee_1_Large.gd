extends Entity

var player: Node
@export var tier = 1

func _ready():
	player = get_node("/root/Game/Player")


func _physics_process(delta):
	get_dirction_to_player()
	move()
	check_for_enemies()
	if closets_enemy != null:
		if can_attack:do_melee_attack()
