extends Entity

var player: Node
@export var tier = 1
var preparing_dash = false
@export var distance_for_performance_dash = 100

func _ready():
	player = get_node("/root/Game/Player")


func _physics_process(delta):
	check_for_enemies()
	if global_position.distance_to(player.global_position) > 25:
		direction = (player.global_position - global_position).normalized()
	else: direction = Vector2.ZERO
	
	if global_position.distance_to(player.global_position) < 100 and !dash_on_cooldown:
		var tween = get_tree().create_tween()
		preparing_dash = true
		direction = Vector2.ZERO
		tween.tween_callback(perform_dash).set_delay(1)		
	if !die:
		if !preparing_dash:move(delta)
	if closets_enemy != null:
		if can_attack:do_melee_attack()

func perform_dash():
	preparing_dash = false
	direction = (player.global_position - global_position).normalized()
	do_dash()
