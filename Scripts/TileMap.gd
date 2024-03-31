extends TileMap

var tile_set_array = []
var map_size = 50
var nav_region: NavigationRegion2D

func _ready():
	nav_region = $NavigationRegion2D
	for i in range(3,5):
		for e in range(0,2):
			tile_set_array.append(Vector2i(i,e))
	create_map()


func create_map():
	for i in range(-map_size,map_size):
		for e in range(-map_size,map_size):
			set_cell(0,Vector2i(i,e),0,tile_set_array.pick_random())

