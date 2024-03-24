extends Control

var player: Node
var health_label: Label
var health_bar:ProgressBar
var dash_buttom:Button

func _ready():
	player = get_node("/root/Game/Player")
	health_bar = $HBoxContainer/Control/Health_Bar
	health_label = $HBoxContainer/Control/Health_Label
	dash_buttom = $HBoxContainer/Dash_Button

func _process(delta):
	health_bar.value = player.health
	health_bar.max_value = player.max_health
	health_label.text = str(player.health) + "/" + str(player.max_health)
	
	if player.dash_timer.is_stopped() or player.is_dashing:
		dash_buttom.text = "Dash"
	else:
		dash_buttom.text = str(int(player.dash_timer.time_left))
