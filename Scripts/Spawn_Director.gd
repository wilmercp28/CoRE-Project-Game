extends Node


var tier_1_enemies = []
var tier_2_enemies = []
var current_enemies = 0
@export var spawn_point: Marker2D

func _ready():
	get_enemies_dir("res://Scenes/Enemy Types/")

func _process(delta):
	if current_enemies < 300:
		var enemy_instance = tier_1_enemies.pick_random().instantiate()
		enemy_instance.global_position = spawn_point.global_position
		get_parent().add_child(enemy_instance)
		current_enemies += 1

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
