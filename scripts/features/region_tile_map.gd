extends TileMap

var LOADED = 0
var KNOWN = 1
var ERROR = 2

func display_grid(grid):
	clear()
	
	var max_x = 0
	var max_z = 0
	
	for region in grid:
		if max_x < region.x:
			max_x = region.x
		if max_z < region.z:
			max_z = region.z
	
	for region in grid:
		set_cellv(Vector2(region.x/(max_x), region.z/(max_z)+1), 1)

