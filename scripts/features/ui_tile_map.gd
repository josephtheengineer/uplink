extends TileMap

var LOADED = 0
var KNOWN = 1
var ERROR = 2

func display_grid(grid: Dictionary, offset: Vector2):
	clear()
	offset = Vector2(0, 0)
	
	var max_x = grid.keys().max().x
	var max_z = grid.keys().max().z
	
	print("Max map: " + str(Vector2(max_x, max_z)))
	
	
	var min_x = grid.keys().min().x
	var min_z = grid.keys().min().z
	
	print("Min map: " + str(Vector2(min_x, min_z)))
	
	max_x = max_x - min_x
	max_z = max_z - min_z
	
	print("New max map: " + str(Vector2(max_x, max_z)))
	
	cell_size.x = 608/max_x
	cell_size.y = 436/max_z
	
	if cell_size > Vector2(32, 32):
		cell_size = Vector2(32, 32)
	
	print("Cell size: " + str(cell_size))
	
	for item in grid:
		var x = int(item.x-min_x + offset.x)
		var y = int(item.z-min_z + offset.y)
		print(Vector2(x, y))
		set_cellv(Vector2(x, y), 1)

