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

const SURROUNDING_BLOCKS = [
			Vector3(0, 0, 1), Vector3(0, 1, 0), 
			Vector3(1, 0, 0), Vector3(0, 0, -1), 
			Vector3(0, -1, 0), Vector3(-1, 0, 0)
]

const SURROUNDING_BLOCKS_SQUARE = [
			Vector3(0, 0, 1), Vector3(0, 1, 0), 
			Vector3(1, 0, 0), Vector3(0, 0, -1), 
			Vector3(0, -1, 0), Vector3(-1, 0, 0),
			Vector3(-1, 1, 0), Vector3(-1, -1, 0),
			Vector3(1, -1, 0), Vector3(1, 1, 0),
			Vector3(0, -1, 1), Vector3(0, -1, -1),
			Vector3(0, 1, -1), Vector3(0, 1, 1)
]

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

# chunk.geometry.can_be_seen ###################################################
const can_be_seen_meta := {
	func_name = "chunk.geometry.can_be_seen",
	description = """
		Runs once per voxel!
	""",
		position = null,
		voxel_data = {},
		surrounding_voxels = [],
		square = false}
static func can_be_seen(args := can_be_seen_meta) -> void: #####################
	var positions = SURROUNDING_BLOCKS
	if args.square:
		positions = SURROUNDING_BLOCKS_SQUARE
	
	for surrounding_position in positions:
		if args.voxel_data.has(args.position + surrounding_position):
			args.surrounding_voxels.append(surrounding_position)
# ^ chunk.geometry.can_be_seen #################################################


# chunk.geometry.create_cube ###################################################
const create_cube_meta := {
	func_name = "chunk.geometry.create_cube",
	description = """
		Runs once per block!
	""",
		position = null,
		voxel_data = {},
		mesh = []}
static func create_cube(args := create_cube_meta) -> void: #####################
	#var variable_voxel_data = Core.run("chunk.optimize.optimize_voxels", {voxel_data=args.voxel_data}).variable_voxel_data
	args.mesh.resize(Mesh.ARRAY_MAX)
	
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	#var indices = PoolIntArray()
	
#	var num_of_sides = 6
#	args.mesh[Mesh.ARRAY_NORMAL].resize(num_of_sides*voxel_data.size())
#	args.mesh[Mesh.ARRAY_TEX_UV].resize(vplane_uvs.size()*num_of_sides*voxel_data.size())
#	args.mesh[Mesh.ARRAY_VERTEX].resize(vplane_vertices.size()*num_of_sides*voxel_data.size())
	
	for variable_voxel_position in args.voxel_data:
		var uv_offset = Vector2(-0.5, -0.5)
		if floor(rand_range(0, 3)) == 1:
			uv_offset = Vector2(0, 0)
		
		var surrounding_voxels = Core.run(
				"chunk.geometry.can_be_seen", {
					position = variable_voxel_position, 
					voxel_data = args.voxel_data
				}).surrounding_voxels
		
		var real_block_pos = args.position + Vector3(8, 8, 8)
		var real_voxel_pos = real_block_pos + (variable_voxel_position / Vector3(15, 15, 15))
		var voxel_array = Core.run(
			"chunk.geometry.create_voxel", {
				position = real_voxel_pos,
				uv_offset = uv_offset, 
				sides_not_to_render = surrounding_voxels,
				#size = variable_voxel_data[variable_voxel_position]
			}).mesh
			
		verts.append_array(voxel_array[Mesh.ARRAY_VERTEX])
		uvs.append_array(voxel_array[Mesh.ARRAY_TEX_UV])
		normals.append_array(voxel_array[Mesh.ARRAY_NORMAL])
	
	args.mesh[Mesh.ARRAY_VERTEX] = verts
	args.mesh[Mesh.ARRAY_TEX_UV] = uvs
	args.mesh[Mesh.ARRAY_NORMAL] = normals
# ^ chunk.geometry.create_cube #################################################


# chunk.geometry.create_voxel ##################################################
const create_voxel_meta := {
	func_name = "chunk.geometry.create_voxel",
	description = """
		Runs once per voxel!
	""",
		position = null,
		uv_offset = null,
		sides_not_to_render = [],
		size = Vector3(1, 1, 1),
		mesh = []}
static func create_voxel(args := create_voxel_meta) -> void: ###################	
	var vsize = args.size/16 #Vector3(2, 2, 2) / 16 #sqrt((diffx * diffx) + (diffy * diffy) + (diffz * diffz)) / 16
	#Core.emit_signal("msg", "Setting voxel size to " + str(vsize), Core.DEBUG, args)
	
	# xplane data ##########################################################
	var xplane_uvs = [
		Vector2(0, vsize.y), 
		Vector2(vsize.x, vsize.y), 
		Vector2(0, 0), 
		Vector2(vsize.x, 0), 
		Vector2(0, 0), 
		Vector2(vsize.x, vsize.y)
	]
	
	var xplane_vertices = [ 
		Vector3(0,  vsize.y/2, -vsize.x/2), # top corner
		Vector3(0,  vsize.y/2,  vsize.x/2), # right
		Vector3(0, -vsize.y/2, -vsize.x/2), # down angle
		
		Vector3(0, -vsize.y/2,  vsize.x/2), # bottom corner
		Vector3(0, -vsize.y/2, -vsize.x/2), # left
		Vector3(0,  vsize.y/2,  vsize.x/2), # top angle
	]
	
	# yplane data ##########################################################
	var yplane_uvs = [ 
		Vector2(0, 0), 
		Vector2(vsize.x, 0), 
		Vector2(0, vsize.y), 
		Vector2(vsize.x, vsize.y), 
		Vector2(0, vsize.y), 
		Vector2(vsize.x, 0)
	]
	
	var yplane_vertices = [ 
		Vector3(-vsize.x/2, 0,  vsize.z/2), # top corner
		Vector3( vsize.x/2, 0,  vsize.z/2), # right
		Vector3(-vsize.x/2, 0, -vsize.z/2), # down angle
		
		Vector3( vsize.x/2, 0, -vsize.z/2), # bottom corner
		Vector3(-vsize.x/2, 0, -vsize.z/2), # left
		Vector3( vsize.x/2, 0,  vsize.z/2), # top angle
	]
	
	# zplane data ##########################################################
	var zplane_uvs = [
		Vector2(0, vsize.y), 
		Vector2(vsize.x, vsize.y), 
		Vector2(0, 0), 
		Vector2(vsize.x, 0), 
		Vector2(0, 0), 
		Vector2(vsize.x, vsize.y)
	]
	
	var zplane_vertices = [ 
		Vector3(-vsize.x/2,  vsize.y/2, 0), # top corner
		Vector3( vsize.x/2,  vsize.y/2, 0), # right
		Vector3(-vsize.x/2, -vsize.y/2, 0), # down angle
		
		Vector3( vsize.x/2, -vsize.y/2, 0), # bottom corner
		Vector3(-vsize.x/2, -vsize.y/2, 0), # left
		Vector3( vsize.x/2,  vsize.y/2, 0), # top angle
	]
	
	
	args.mesh.resize(Mesh.ARRAY_MAX)
	
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	#var indices = PoolIntArray()
	
	
	#var start = OS.get_ticks_msec()
	#var num_of_sides = sides_not_to_render.size() - SURROUNDING_BLOCKS.size()
	
	if not args.sides_not_to_render.has(Vector3(0, 1, 0)) or SHOW_UNSEEN_SIDES: # up
		for i in range(yplane_vertices.size()):
			normals.append(Vector3(0, 1, 0))
			uvs.append(yplane_uvs[i] + args.uv_offset)
			verts.append(yplane_vertices[i] + args.position - Vector3(0, vsize.y/2, 0))

	if not args.sides_not_to_render.has(Vector3(0, -1, 0)) or SHOW_UNSEEN_SIDES: # down
		var i = yplane_vertices.size()
		for _index in range(yplane_vertices.size()):
			i -= 1
			normals.append(Vector3(0, -1, 0))
			uvs.append(yplane_uvs[i] + args.uv_offset)
			verts.append(yplane_vertices[i] + args.position + Vector3(0, vsize.y/2, 0))
	
	
	
	if not args.sides_not_to_render.has(Vector3(0, 0, 1)) or SHOW_UNSEEN_SIDES: # west
		for i in range(zplane_vertices.size()):
			normals.append(Vector3(0, 0, 1))
			uvs.append(zplane_uvs[i] + args.uv_offset)
			verts.append(zplane_vertices[i] + args.position + Vector3(0, 0, vsize.z/2))
			
	
	if not args.sides_not_to_render.has(Vector3(0, 0, -1)) or SHOW_UNSEEN_SIDES: # east
		var i = zplane_vertices.size()
		for _index in range(zplane_vertices.size()):
			i -= 1
			normals.append(Vector3(0, 0, -1))
			uvs.append(zplane_uvs[i] + args.uv_offset)
			verts.append(zplane_vertices[i] + args.position - Vector3(0, 0, vsize.z/2))
	
	if not args.sides_not_to_render.has(Vector3(-1, 0, 0)) or SHOW_UNSEEN_SIDES: # north
		for i in range(xplane_vertices.size()):
			normals.append(Vector3(-1, 0, 0))
			uvs.append(xplane_uvs[i] + args.uv_offset)
			verts.append(xplane_vertices[i] + args.position - Vector3(vsize.x/2, 0, 0))

	if not args.sides_not_to_render.has(Vector3(1, 0, 0)) or SHOW_UNSEEN_SIDES: # south
		var i = xplane_vertices.size()
		for _index in range(xplane_vertices.size()):
			i -= 1
			normals.append(Vector3(1, 0, 0))
			uvs.append(xplane_uvs[i] + args.uv_offset)
			verts.append(xplane_vertices[i] + args.position + Vector3(vsize.x/2, 0, 0))
	
	args.mesh[Mesh.ARRAY_VERTEX] = verts
	args.mesh[Mesh.ARRAY_TEX_UV] = uvs
	args.mesh[Mesh.ARRAY_NORMAL] = normals
	#args.mesh[Mesh.ARRAY_INDEX] = indices
	
	#Core.emit_signal("msg", "create_voxel() took " + str(OS.get_ticks_msec()-start) + "ms", Core.TRACE, args)
# ^ chunk.geometry.create_voxel ################################################
