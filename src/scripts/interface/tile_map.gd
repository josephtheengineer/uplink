extends TileMap
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.tile_map",
	type = "impure",
	description = """
		
	"""
}

enum {LOADED, KNOWN, ERROR}

func display_grid(_grid: Dictionary, _offset: Vector2): ##########################
	pass
#	clear()
#	offset = Vector2(0, 0)
#
#	var max_x: float = grid.keys().max().x
#	var max_z: float = grid.keys().max().z
#
#	var min_x: float  = grid.keys().min().x
#	var min_z: float  = grid.keys().min().z
#
#	max_x = max_x - min_x
#	max_z = max_z - min_z
#
#	cell_size.x = 608/max_x
#	cell_size.y = 436/max_z
#
#	if cell_size > Vector2(32, 32):
#		cell_size = Vector2(32, 32)
#
#	for item in grid:
#		var x := int(item.x-min_x + offset.x)
#		var y := int(item.z-min_z + offset.y)
#		set_cellv(Vector2(x, y), 1)
