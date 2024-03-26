extends Entity

var player: Node
@export var tier = 1

func _ready():
	player = get_node("/root/Game/Player")

func _physics_process(delta):
	closets_enemy = player
	check_for_player()
	move()
	if closets_enemy != null:
		if can_attack:do_melee_attack()
		
