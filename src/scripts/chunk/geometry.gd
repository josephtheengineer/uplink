#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.geometry",
	description = """
		
	"""
}

const SHOW_UNSEEN_SIDES = false
const BSIZE = 1.0         # Block size       (1)
const VSIZE = BSIZE / 16  # Voxel size       (0.0625)
const MVSIZE = VSIZE / 16 # Micro voxel size (0.00390625)
const CSIZE = BSIZE * 16  # Chunk size       (16)

const SURROUNDING_BLOCKS = [ Vector3(0, 0, 1), Vector3(0, 1, 0), 
	Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0), 
	Vector3(-1, 0, 0) ]

const CHUNK_HIGHLIGHT = [
	Vector3(0, 0, 0), Vector3(CSIZE, 0, 0), # ______
	
	Vector3(CSIZE, 0, 0), Vector3(CSIZE, CSIZE, 0), #      |
	
	Vector3(0, CSIZE, 0), Vector3(0, 0, 0), # |
	
	Vector3(0, 0, CSIZE), Vector3(CSIZE, 0, CSIZE), # ------
	
	Vector3(CSIZE, 0, CSIZE), Vector3(CSIZE, CSIZE, CSIZE), #       |
	
	Vector3(0, CSIZE, CSIZE), Vector3(0, 0, CSIZE), # |
	
	Vector3(0, CSIZE, 0), Vector3(0, CSIZE, CSIZE), # ^/
	
	Vector3(0, 0, 0), Vector3(0, 0, CSIZE), # /
	
	Vector3(CSIZE, CSIZE, 0), Vector3(CSIZE, CSIZE, CSIZE), #      ^/
	
	Vector3(CSIZE, 0, 0), Vector3(CSIZE, 0, CSIZE), #        /
	
	Vector3(0, CSIZE, 0), Vector3(CSIZE, CSIZE, 0), # ^______
	
	Vector3(0, CSIZE, CSIZE), Vector3(CSIZE, CSIZE, CSIZE) # ^------
]

const BLOCK_HIGHLIGHT = [
	Vector3(0, 0, 0), Vector3(BSIZE, 0, 0), # ______
	
	Vector3(BSIZE, 0, 0), Vector3(BSIZE, BSIZE, 0), #      |
	
	Vector3(0, BSIZE, 0), Vector3(0, 0, 0), # |
	
	Vector3(0, 0, BSIZE), Vector3(BSIZE, 0, BSIZE), # ------
	
	Vector3(BSIZE, 0, BSIZE), Vector3(BSIZE, BSIZE, BSIZE), #       |
	
	Vector3(0, BSIZE, BSIZE), Vector3(0, 0, BSIZE), # |
	
	Vector3(0, BSIZE, 0), Vector3(0, BSIZE, BSIZE), # ^/
	
	Vector3(0, 0, 0), Vector3(0, 0, BSIZE), # /
	
	Vector3(BSIZE, BSIZE, 0), Vector3(BSIZE, BSIZE, BSIZE), #      ^/
	
	Vector3(BSIZE, 0, 0), Vector3(BSIZE, 0, BSIZE), #        /
	
	Vector3(0, BSIZE, 0), Vector3(BSIZE, BSIZE, 0), # ^______
	
	Vector3(0, BSIZE, BSIZE), Vector3(BSIZE, BSIZE, BSIZE) # ^------
]

const VOXEL_HIGHLIGHT = [
	Vector3(0, 0, 0),         Vector3(VSIZE, 0, 0),         # ______
	
	Vector3(VSIZE, 0, 0),     Vector3(VSIZE, VSIZE, 0),     #      |
	
	Vector3(0, VSIZE, 0),     Vector3(0, 0, 0),             # |
	
	Vector3(0, 0, VSIZE),     Vector3(VSIZE, 0, VSIZE),     # ------
	
	Vector3(VSIZE, 0, VSIZE), Vector3(VSIZE, VSIZE, VSIZE), #       |
	
	Vector3(0, VSIZE, VSIZE), Vector3(0, 0, VSIZE),         # |
	
	Vector3(0, VSIZE, 0),     Vector3(0, VSIZE, VSIZE),     # ^/
	
	Vector3(0, 0, 0),         Vector3(0, 0, VSIZE),         # /
	
	Vector3(VSIZE, VSIZE, 0), Vector3(VSIZE, VSIZE, VSIZE), #      ^/
	
	Vector3(VSIZE, 0, 0),     Vector3(VSIZE, 0, VSIZE),     #        /
	
	Vector3(0, VSIZE, 0),     Vector3(VSIZE, VSIZE, 0),     # ^______
	
	Vector3(0, VSIZE, VSIZE), Vector3(VSIZE, VSIZE, VSIZE)  # ^------
]

################################################################################

static func can_be_seen(position: Vector3, voxel_data: Dictionary):
	var num_surrounding_voxels = [ ]
	
	for surrounding_position in SURROUNDING_BLOCKS:
		if voxel_data.has(position + surrounding_position*VSIZE):
			num_surrounding_voxels.append(surrounding_position*VSIZE)
	return num_surrounding_voxels

static func block_can_be_seen(position: Vector3, block_data: Dictionary):
	var num_surrounding_blocks = [ ]
	
	for surrounding_position in SURROUNDING_BLOCKS:
		if block_data.has(position + surrounding_position):
			num_surrounding_blocks.append(surrounding_position)
	return num_surrounding_blocks

static func create_cube(position: Vector3, voxel_data: Dictionary, mesh: SurfaceTool, block_data: Dictionary):
	var vertex_data = []
	#var st = SurfaceTool.new()
	#st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#st.set_material(materials[id])
	
	for voxel_position in voxel_data:
		var uv_offset = Vector2(-0.5, -0.5)
		if floor(rand_range(0, 3)) == 1:
			uv_offset = Vector2(0, 0)
		var voxel = create_voxel(position + voxel_position, block_data, mesh, uv_offset)
		#print(voxel.vertex_data)
		vertex_data += voxel.vertex_data
	
	#return { "mesh" : st.commit(mesh), "vertex_data" : vertex_data }
	#Core.emit_signal("msg", "Vertex size: " + str(vertex_data.size()), Core.TRACE, meta)
	#Core.emit_signal("msg", "Vertices: " + str(vertex_data), Core.TRACE, meta)
	return { "mesh" : mesh, "vertex_data" : vertex_data }

static func create_voxel(position: Vector3, block_data: Dictionary, mesh: SurfaceTool, uv_offset: Vector2):
	var vertex_data = []
	var sides_not_to_render = can_be_seen(position, block_data)
	
	if not sides_not_to_render.has(Vector3(0, -1, 0)) or SHOW_UNSEEN_SIDES:
		vertex_data += create_horizontal_plane(mesh, position 
			+ Vector3(0, -VSIZE, 0), "down", uv_offset)
	
	if not sides_not_to_render.has(Vector3(0, 1, 0)) or SHOW_UNSEEN_SIDES: 
		vertex_data += create_horizontal_plane(mesh, position 
			+ Vector3(0, 0, 0), "up", uv_offset)
	
	
	
	if not sides_not_to_render.has(Vector3(0, 0, 1)) or SHOW_UNSEEN_SIDES:
		vertex_data += create_vertical_plane(mesh, position + Vector3(0, 0, VSIZE), "west", uv_offset)
	
	if not sides_not_to_render.has(Vector3(0, 0, -1)) or SHOW_UNSEEN_SIDES:
		vertex_data += create_vertical_plane(mesh, position + Vector3(0, 0, 0), "east", uv_offset)
	
	if not sides_not_to_render.has(Vector3(-1, 0, 0)) or SHOW_UNSEEN_SIDES:
		vertex_data += create_vertical_plane(mesh, position + Vector3(0, 0, 0), "north", uv_offset)
	
	if not sides_not_to_render.has(Vector3(1, 0, 0)) or SHOW_UNSEEN_SIDES:
		vertex_data += create_vertical_plane(mesh, position + Vector3(VSIZE, 0, 0), "south", uv_offset)
	
	return { "mesh" : mesh, "vertex_data" : vertex_data }

# for voxels
const vplane_uvs = [ Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, 0), Vector2(VSIZE, VSIZE) ]
const vplane_vertices = [ Vector3(0, 0, 0), Vector3(VSIZE, 0, 0), Vector3(0, -VSIZE, 0), Vector3(VSIZE, -VSIZE, 0), Vector3(0, -VSIZE, 0), Vector3(VSIZE, 0, 0) ]

const vplane_uvs2 = [ Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, 0), Vector2(VSIZE, VSIZE) ]
const vplane_vertices2 = [ Vector3(0, 0, 0), Vector3(0, 0, VSIZE), Vector3(0, -VSIZE, 0), Vector3(0, -VSIZE, VSIZE), Vector3(0, -VSIZE, 0), Vector3(0, 0, VSIZE) ]

static func create_vertical_plane(st: SurfaceTool, position: Vector3, direction: String, uv_offset: Vector2):
	#print(str(st), str(position), str(direction))
	#print(str(vplane_vertices))
	#print(str(VSIZE))
	#print(str(-VSIZE))
	var vertex_data = []
	if direction == "west":
		for i in range(vplane_vertices.size()):
			st.add_uv(vplane_uvs[i] + uv_offset)
			st.add_vertex(vplane_vertices[i] + position)
			vertex_data.append(vplane_vertices[i] + position)
	
	
	elif direction == "east":
		vplane_vertices.invert()
		vplane_uvs.invert()
		for i in range(vplane_vertices.size()):
			st.add_uv(vplane_uvs[i] + uv_offset)
			st.add_vertex(vplane_vertices[i] + position)
			vertex_data.append(vplane_vertices[i] + position)
		
		vplane_vertices.invert()
		vplane_uvs.invert()
	
	
	
	elif direction == "north":
		for i in range(vplane_vertices2.size()):
			st.add_uv(vplane_uvs2[i] + uv_offset)
			st.add_vertex(vplane_vertices2[i] + position)
			vertex_data.append(vplane_vertices2[i] + position)
	
	elif direction == "south":
		vplane_vertices2.invert()
		vplane_uvs2.invert()
		for i in range(vplane_vertices2.size()):
			st.add_uv(vplane_uvs2[i] + uv_offset)
			st.add_vertex(vplane_vertices2[i] + position)
			vertex_data.append(vplane_vertices2[i] + position)
		
		vplane_vertices2.invert()
		vplane_uvs2.invert()
	return vertex_data

const hplane_uvs = [ Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, VSIZE), Vector2(VSIZE, 0) ]
const hplane_vertices = [ Vector3(0, 0, 0), Vector3(VSIZE, 0, 0), Vector3(0, 0, VSIZE), Vector3(VSIZE, 0, VSIZE), Vector3(0, 0, VSIZE), Vector3(VSIZE, 0, 0) ]

static func create_horizontal_plane(st: SurfaceTool, position: Vector3, direction: String, uv_offset: Vector2):
	var vertex_data = []
	if direction == "up":
		for i in range(hplane_vertices.size()):
			st.add_uv(hplane_uvs[i] + uv_offset)
			st.add_vertex(hplane_vertices[i] + position)
			vertex_data.append(hplane_vertices[i] + position)
		
	elif direction == "down":
		hplane_vertices.invert()
		hplane_uvs.invert()
		for i in range(hplane_vertices.size()):
			st.add_uv(hplane_uvs[i] + uv_offset)
			st.add_vertex(hplane_vertices[i] + position)
			vertex_data.append(hplane_vertices[i] + position)
		
		hplane_vertices.invert()
		hplane_uvs.invert()
	return vertex_data


## for blocks (no longer used)
#const vertical_plane_uvs_block = [ Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), Vector2(1, 1) ]
#const vertical_plane_vertices_block = [ Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(1, -1, 0), Vector3(0, -1, 0), Vector3(1, 0, 0) ]
#
#const vertical_plane_uvs2_block = [ Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), Vector2(1, 1) ]
#const vertical_plane_vertices2_block = [ Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, -1, 1), Vector3(0, -1, 0), Vector3(0, 0, 1) ]
#
#static func create_vertical_plane_block(st, position, direction):
#	var vertex_data = []
#	if direction == "west":
#		for i in range(vertical_plane_vertices.size()):
#			st.add_uv(vertical_plane_uvs[i])
#			st.add_vertex(vertical_plane_vertices[i] + position)
#			vertex_data.append(vertical_plane_vertices[i] + position)
#
#	elif direction == "east":
#		vertical_plane_vertices.invert()
#		vertical_plane_uvs.invert()
#		for i in range(vertical_plane_vertices.size()):
#			st.add_uv(vertical_plane_uvs[i])
#			st.add_vertex(vertical_plane_vertices[i] + position)
#			vertex_data.append(vertical_plane_vertices[i] + position)
#
#		vertical_plane_vertices.invert()
#		vertical_plane_uvs.invert()
#
#
#
#	elif direction == "north":
#		for i in range(vertical_plane_vertices2.size()):
#			st.add_uv(vertical_plane_uvs2[i])
#			st.add_vertex(vertical_plane_vertices2[i] + position)
#			vertex_data.append(vertical_plane_vertices2[i] + position)
#
#	elif direction == "south":
#		vertical_plane_vertices2.invert()
#		vertical_plane_uvs2.invert()
#		for i in range(vertical_plane_vertices2.size()):
#			st.add_uv(vertical_plane_uvs2[i])
#			st.add_vertex(vertical_plane_vertices2[i] + position)
#			vertex_data.append(vertical_plane_vertices2[i] + position)
#
#		vertical_plane_vertices2.invert()
#		vertical_plane_uvs2.invert()
#	return vertex_data
#
#const horizontal_plane_uvs_block = [ Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(0, 1), Vector2(1, 0) ]
#const horizontal_plane_vertices_block = [ Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(0, 0, 1), Vector3(1, 0, 0) ]
#
#static func create_horizontal_plane_block(st, position, direction):
#	var vertex_data = []
#	if direction == "up":
#		for i in range(horizontal_plane_vertices.size()):
#			st.add_uv(horizontal_plane_uvs[i])
#			st.add_vertex(horizontal_plane_vertices[i] + position)
#			vertex_data.append(horizontal_plane_vertices[i] + position)
#
#	elif direction == "down":
#		horizontal_plane_vertices.invert()
#		horizontal_plane_uvs.invert()
#		for i in range(horizontal_plane_vertices.size()):
#			st.add_uv(horizontal_plane_uvs[i])
#			st.add_vertex(horizontal_plane_vertices[i] + position)
#			vertex_data.append(horizontal_plane_vertices[i] + position)
#
#		horizontal_plane_vertices.invert()
#		horizontal_plane_uvs.invert()
#	return vertex_data
