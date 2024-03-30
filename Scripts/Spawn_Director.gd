extends Node


var spawn_delay_timer: Timer
var spawn_delay = 5
var can_spawn = true
var tier_1_enemies = []
var tier_2_enemies = []
var spawn_points: Array
var number = 1

func _ready():
	get_enemies_dir("res://Scenes/Enemy Types/")
	spawn_delay_timer = get_node("/root/Game/Spawn_Director/Timer")
	get_spawnPoints()
	connect_timer()
	
func connect_timer():
	spawn_delay_timer.timeout.connect(_on_timer_timeout)
	spawn_delay_timer.one_shot = true
	
func _on_timer_timeout():
	can_spawn = true
	
func get_spawnPoints():
	var spawnPoint = get_node("/root/Game/Player/Marker2D" + str(number))
	if spawnPoint != null:
		spawn_points.append(spawnPoint)
		number += 1
		get_spawnPoints()

func _process(delta):
	print(can_spawn)
	if !tier_1_enemies.is_empty() and can_spawn:
			var enemy_instance = tier_1_enemies.pick_random().instantiate()
			enemy_instance.global_position = spawn_points.pick_random().global_position
			get_parent().add_child(enemy_instance)
			can_spawn = false
			spawn_delay_timer.start(spawn_delay)

func get_enemies_dir(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var enemy = load("res://Scenes/Enemy Types/" + file_name)
			var enemy_instance = enemy.instantiate()
			if enemy_instance.tier == 1:
				tier_1_enemies.append(enemy)
			if enemy_instance.tier == 2:
				tier_2_enemies.append(enemy)
			enemy_instance.queue_free()
			file_name = dir.get_next()
