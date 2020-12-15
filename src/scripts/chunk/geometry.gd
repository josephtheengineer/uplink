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

const BOX_HIGHLIGHT_NO_OVERLAP = [
	Vector3(0, 0, 0), Vector3(0.999, 0, 0),                 # ______
	
	Vector3(0.999, 0, 0), Vector3(0.999, 0.999, 0),         #      |
	
	Vector3(0, 0.999, 0), Vector3(0, 0, 0),                 # |
	
	Vector3(0, 0, 0.999), Vector3(0.999, 0, 0.999),         # ------
	
	Vector3(0.999, 0, 0.999), Vector3(0.999, 0.999, 0.999), #       |
	
	Vector3(0, 0.999, 0.999), Vector3(0, 0, 0.999),         # |
	
	Vector3(0, 0.999, 0), Vector3(0, 0.999, 0.999),         # ^/
	
	Vector3(0, 0, 0), Vector3(0, 0, 0.999),                 # /
	
	Vector3(0.999, 0.999, 0), Vector3(0.999, 0.999, 0.999), #      ^/
	
	Vector3(0.999, 0, 0), Vector3(0.999, 0, 0.999),         #        /
	
	Vector3(0, 0.999, 0), Vector3(0.999, 0.999, 0),         # ^______
	
	Vector3(0, 0.999, 0.999), Vector3(0.999, 0.999, 0.999)  # ^------
]

# for voxels
const vplane_uvs = [ Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, 0), Vector2(VSIZE, VSIZE) ]
const vplane_vertices = [ Vector3(0, 0, 0), Vector3(VSIZE, 0, 0), Vector3(0, -VSIZE, 0), Vector3(VSIZE, -VSIZE, 0), Vector3(0, -VSIZE, 0), Vector3(VSIZE, 0, 0) ]

const vplane_uvs2 = [ Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, 0), Vector2(VSIZE, VSIZE) ]
const vplane_vertices2 = [ Vector3(0, 0, 0), Vector3(0, 0, VSIZE), Vector3(0, -VSIZE, 0), Vector3(0, -VSIZE, VSIZE), Vector3(0, -VSIZE, 0), Vector3(0, 0, VSIZE) ]

const hplane_uvs = [ Vector2(0, 0), Vector2(VSIZE, 0), Vector2(0, VSIZE), Vector2(VSIZE, VSIZE), Vector2(0, VSIZE), Vector2(VSIZE, 0) ]
const hplane_vertices = [ Vector3(0, 0, 0), Vector3(VSIZE, 0, 0), Vector3(0, 0, VSIZE), Vector3(VSIZE, 0, VSIZE), Vector3(0, 0, VSIZE), Vector3(VSIZE, 0, 0) ]


# chunk.geometry.can_be_seen ###################################################
const can_be_seen_meta := {
	func_name = "chunk.geometry.can_be_seen",
	description = """
		Runs once per voxel!
	""",
		}
static func can_be_seen(position: Vector3, voxel_data: Dictionary, args := can_be_seen_meta) -> Array:
	var num_surrounding_voxels = [ ]
	
	for surrounding_position in SURROUNDING_BLOCKS:
		if voxel_data.has(position + surrounding_position*VSIZE):
			num_surrounding_voxels.append(surrounding_position)
	
	return num_surrounding_voxels
# ^ chunk.geometry.can_be_seen #################################################


# chunk.geometry.block_can_be_seen #############################################
const block_can_be_seen_meta := {
	func_name = "chunk.geometry.block_can_be_seen",
	description = """
		Runs once per block!
	""",
		}
static func block_can_be_seen(position: Vector3, block_data: Array, args := block_can_be_seen_meta) -> Array:
	var num_surrounding_blocks = [ ]
	
	for surrounding_position in SURROUNDING_BLOCKS:
		if block_data.has(position + surrounding_position):
			num_surrounding_blocks.append(surrounding_position)
	return num_surrounding_blocks
# ^ chunk.geometry.block_can_be_seen ###########################################


# chunk.geometry.create_cube ###################################################
const create_cube_meta := {
	func_name = "chunk.geometry.create_cube",
	description = """
		Runs once per block!
	""",
		}
static func create_cube(position: Vector3, voxel_data: Dictionary, args := create_cube_meta) -> Array:
	var mesh_arrays = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	#var indices = PoolIntArray()
	
#	var num_of_sides = 6
#	mesh_arrays[Mesh.ARRAY_NORMAL].resize(num_of_sides*voxel_data.size())
#	mesh_arrays[Mesh.ARRAY_TEX_UV].resize(vplane_uvs.size()*num_of_sides*voxel_data.size())
#	mesh_arrays[Mesh.ARRAY_VERTEX].resize(vplane_vertices.size()*num_of_sides*voxel_data.size())
	
	for voxel_position in voxel_data:
		var uv_offset = Vector2(-0.5, -0.5)
		if floor(rand_range(0, 3)) == 1:
			uv_offset = Vector2(0, 0)
		#var sides_not_to_render = can_be_seen(voxel_position, voxel_data)
		
		var rvoxel_position = position + (voxel_position/Vector3(16, 16, 16))# + Vector3(0, resolution, 0)
		var voxel_array = create_voxel(rvoxel_position, uv_offset, Array())
		
		verts.append_array(voxel_array[Mesh.ARRAY_VERTEX])
		uvs.append_array(voxel_array[Mesh.ARRAY_TEX_UV])
		normals.append_array(voxel_array[Mesh.ARRAY_NORMAL])
		#indices.append_array(voxel_array[Mesh.ARRAY_INDEX])
	
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	#mesh_arrays[Mesh.ARRAY_INDEX] = indices
	
	Core.emit_signal("msg", "")
	return mesh_arrays
# ^ chunk.geometry.create_cube #################################################


# chunk.geometry.create_voxel ##################################################
const create_voxel_meta := {
	func_name = "chunk.geometry.create_voxel",
	description = """
		Runs once per voxel!
	""",
		}
static func create_voxel(position: Vector3, uv_offset: Vector2, sides_not_to_render: Array, args := create_voxel_meta) -> Array:
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
		for _index in range(hplane_vertices.size()):
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
		for _index in range(vplane_vertices.size()):
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
		for _index in range(vplane_vertices2.size()):
			i -= 1
			normals.append(Vector3(1, 0, 0))
			uvs.append(vplane_uvs2[i] + uv_offset)
			verts.append(vplane_vertices2[i] + position + Vector3(VSIZE, 0, 0))
	
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	#mesh_arrays[Mesh.ARRAY_INDEX] = indices
	
	#Core.emit_signal("msg", "create_voxel() took " + str(OS.get_ticks_msec()-start) + "ms", Core.TRACE, args)
	return mesh_arrays
# ^ chunk.geometry.create_voxel ################################################
