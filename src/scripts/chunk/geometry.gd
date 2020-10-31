#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.geometry",
	description = """
		Please see src/code/geometry.cpp for the updated version
	"""
}

const SHOW_UNSEEN_SIDES = true
const BSIZE = 1.0         # Block size       (1)
const VSIZE = BSIZE / 16  # Voxel size       (0.0625)
const MVSIZE = VSIZE / 16 # Micro voxel size (0.00390625)
const CSIZE = BSIZE * 16  # Chunk size       (16)

const SURROUNDING_BLOCKS = [ Vector3(0, 0, 1), Vector3(0, 1, 0), 
	Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0), 
	Vector3(-1, 0, 0) ]

const BOX_HIGHLIGHT = [
	Vector3(0, 0, 0), Vector3(1, 0, 0), # ______
	
	Vector3(1, 0, 0), Vector3(1, 1, 0), #      |
	
	Vector3(0, 1, 0), Vector3(0, 0, 0), # |
	
	Vector3(0, 0, 1), Vector3(1, 0, 1), # ------
	
	Vector3(1, 0, 1), Vector3(1, 1, 1), #       |
	
	Vector3(0, 1, 1), Vector3(0, 0, 1), # |
	
	Vector3(0, 1, 0), Vector3(0, 1, 1), # ^/
	
	Vector3(0, 0, 0), Vector3(0, 0, 1), # /
	
	Vector3(1, 1, 0), Vector3(1, 1, 1), #      ^/
	
	Vector3(1, 0, 0), Vector3(1, 0, 1), #        /
	
	Vector3(0, 1, 0), Vector3(1, 1, 0), # ^______
	
	Vector3(0, 1, 1), Vector3(1, 1, 1)  # ^------
]

# for voxels
const vplane_uvs = [ Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, 0), Vector2(VSIZE, VSIZE) ]
const vplane_vertices = [ Vector3(0, 0, 0), Vector3(VSIZE, 0, 0), Vector3(0, -VSIZE, 0), Vector3(VSIZE, -VSIZE, 0), Vector3(0, -VSIZE, 0), Vector3(VSIZE, 0, 0) ]

const vplane_uvs2 = [ Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, 0), Vector2(VSIZE, VSIZE) ]
const vplane_vertices2 = [ Vector3(0, 0, 0), Vector3(0, 0, VSIZE), Vector3(0, -VSIZE, 0), Vector3(0, -VSIZE, VSIZE), Vector3(0, -VSIZE, 0), Vector3(0, 0, VSIZE) ]

const hplane_uvs = [ Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, VSIZE), Vector2(VSIZE, 0) ]
const hplane_vertices = [ Vector3(0, 0, 0), Vector3(VSIZE, 0, 0), Vector3(0, 0, VSIZE), Vector3(VSIZE, 0, VSIZE), Vector3(0, 0, VSIZE), Vector3(VSIZE, 0, 0) ]

################################################################################
# once per voxel ###############################################################
static func can_be_seen(position: Vector3, voxel_data: Dictionary):
	var num_surrounding_voxels = [ ]
	#print("Voxel data: " + str(voxel_data.keys()))
	#print("Position: " + str(position))
	
	for surrounding_position in SURROUNDING_BLOCKS:
		#print(str(position + surrounding_position*VSIZE))
		if voxel_data.has(position + surrounding_position*VSIZE):
			num_surrounding_voxels.append(surrounding_position)
	#print("Surrounding voxels: " + str(num_surrounding_voxels))
	return num_surrounding_voxels

static func block_can_be_seen(position: Vector3, block_data: Array):
	var num_surrounding_blocks = [ ]

	for surrounding_position in SURROUNDING_BLOCKS:
		if block_data.has(position + surrounding_position):
			num_surrounding_blocks.append(surrounding_position)
	return num_surrounding_blocks

# once per block ###############################################################
static func create_cube(position: Vector3, voxel_data: Dictionary, block_data: Dictionary):
	#Core.emit_signal("msg", "ARRAY_MAX is " + str(Mesh.ARRAY_MAX), Core.TRACE, meta)

	var mesh_arrays = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	#var indices = PoolIntArray()
	
	#var start = OS.get_ticks_msec()
#	var num_of_sides = 6
#	mesh_arrays[Mesh.ARRAY_NORMAL].resize(num_of_sides*voxel_data.size())
#	mesh_arrays[Mesh.ARRAY_TEX_UV].resize(vplane_uvs.size()*num_of_sides*voxel_data.size())
#	mesh_arrays[Mesh.ARRAY_VERTEX].resize(vplane_vertices.size()*num_of_sides*voxel_data.size())
	
	for voxel_position in voxel_data:
		var uv_offset = Vector2(-0.5, -0.5)
		if floor(rand_range(0, 3)) == 1:
			uv_offset = Vector2(0, 0)
		var sides_not_to_render = can_be_seen(voxel_position, voxel_data)
		var voxel_array = create_voxel(position+voxel_position, uv_offset, sides_not_to_render)
		
		verts.append_array(voxel_array[Mesh.ARRAY_VERTEX])
		uvs.append_array(voxel_array[Mesh.ARRAY_TEX_UV])
		normals.append_array(voxel_array[Mesh.ARRAY_NORMAL])
		#indices.append_array(voxel_array[Mesh.ARRAY_INDEX])
	
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	#mesh_arrays[Mesh.ARRAY_INDEX] = indices
	
	#Core.emit_signal("msg", "create_cube() took " + str(OS.get_ticks_msec()-start) + "ms", Core.TRACE, meta)
	return mesh_arrays

# once per voxel ###############################################################
static func create_voxel(position: Vector3, uv_offset: Vector2, sides_not_to_render: Array):
	var mesh_arrays = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	#var indices = PoolIntArray()
	
	# Indices are optional in Godot, but if they exist they are used.
#	index_array[0] = 0
#	index_array[1] = 1
#	index_array[2] = 2
#
#	index_array[3] = 2
#	index_array[4] = 3
#	index_array[5] = 0
	
	
	#var start = OS.get_ticks_msec()
	#var num_of_sides = sides_not_to_render.size() - SURROUNDING_BLOCKS.size()
	
	if not sides_not_to_render.has(Vector3(0, 1, 0)) or SHOW_UNSEEN_SIDES: # up
		for i in range(hplane_vertices.size()):
			normals.append(Vector3(0, 1, 0))
			uvs.append(hplane_uvs[i] + uv_offset)
			verts.append(hplane_vertices[i] + position + Vector3(0, 0, 0))
	
	if not sides_not_to_render.has(Vector3(0, -1, 0)) or SHOW_UNSEEN_SIDES: # down
		var i = hplane_vertices.size()
		for index in range(hplane_vertices.size()):
			i -= 1
			normals.append(Vector3(0, -1, 0))
			uvs.append(hplane_uvs[i] + uv_offset)
			verts.append(hplane_vertices[i] + position + Vector3(0, -VSIZE, 0))
	
	
	
	if not sides_not_to_render.has(Vector3(0, 0, 1)) or SHOW_UNSEEN_SIDES: # west
		for i in range(vplane_vertices.size()):
			normals.append(Vector3(0, 0, 1))
			uvs.append(vplane_uvs[i] + uv_offset)
			verts.append(vplane_vertices[i] + position + Vector3(0, 0, VSIZE))

	if not sides_not_to_render.has(Vector3(0, 0, -1)) or SHOW_UNSEEN_SIDES: # east
		var i = hplane_vertices.size()
		for index in range(vplane_vertices.size()):
			i -= 1
			normals.append(Vector3(0, 0, -1))
			uvs.append(vplane_uvs[i] + uv_offset)
			verts.append(vplane_vertices[i] + position + Vector3(0, 0, 0))

	if not sides_not_to_render.has(Vector3(-1, 0, 0)) or SHOW_UNSEEN_SIDES: # north
		for i in range(vplane_vertices2.size()):
			normals.append(Vector3(-1, 0, 0))
			uvs.append(vplane_uvs2[i] + uv_offset)
			verts.append(vplane_vertices2[i] + position + Vector3(0, 0, 0))

	if not sides_not_to_render.has(Vector3(1, 0, 0)) or SHOW_UNSEEN_SIDES: # south
		var i = hplane_vertices.size()
		for index in range(vplane_vertices2.size()):
			i -= 1
			normals.append(Vector3(1, 0, 0))
			uvs.append(vplane_uvs2[i] + uv_offset)
			verts.append(vplane_vertices2[i] + position + Vector3(VSIZE, 0, 0))
	
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	#mesh_arrays[Mesh.ARRAY_INDEX] = indices
	
	#Core.emit_signal("msg", "create_voxel() took " + str(OS.get_ticks_msec()-start) + "ms", Core.TRACE, meta)
	return mesh_arrays









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
