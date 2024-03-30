extends Entity

var player: Node
@export var tier = 1
var preparing_dash = false
@export var distance_for_performance_dash = 100

func _ready():
	player = get_node("/root/Game/Player")


func _physics_process(delta):
	get_dirction_to_player()
	if global_position.distance_to(player.global_position) < 100 and !preparing_dash and !dash_on_cooldown:
		preparing_dash = true
		var tween = get_tree().create_tween()
		tween.tween_callback(perform_dash).set_delay(1)
	if !preparing_dash: move()
	check_for_enemies()
	if closets_enemy != null:
		if can_attack:do_melee_attack()

func perform_dash():
	preparing_dash = false
	move()
	do_dash()
