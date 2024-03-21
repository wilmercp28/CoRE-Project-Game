extends Entity

var player: Node
@export var tier = 1
var preparing_dash = false
@export var distance_for_performance_dash = 100

func _ready():
	player = get_node("/root/Game/Player")


func _physics_process(delta):
	check_for_enemies()
	if global_position.distance_to(player.global_position) > 20:
		direction = (player.global_position - global_position).normalized()
	else: direction = Vector2.ZERO
	if !die:
		if global_position.distance_to(player.global_position) < distance_for_performance_dash and !dash_on_cooldown:
			preparing_dash = true
			var tween = get_tree().create_tween()
			tween.tween_callback(prepare_dash.bind(delta)).set_delay(1)
		if preparing_dash: current_speed = 0
		move(delta)
	if closets_enemy != null:
		if can_attack:do_melee_attack()
func prepare_dash(delta):
	preparing_dash = false
	current_speed = max_speed
	do_dash()
