#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.optimize",
	description = """
		optimizes mesh data
	"""
}

const OPTIMIZE = false

# chunk.optimize.optimize_voxels ###############################################
const optimize_voxels_meta := {
	func_name = "chunk.optimize.optimize_voxels",
	description = """
		global mesh smoothing
	""",
		voxel_data = {},
		variable_voxel_data = {}}
static func optimize_voxels(args := optimize_voxels_meta) -> void: #############
	var removed_voxels = []
	for pos in args.voxel_data:
		#if int(pos.y) % 2 == 0 and int(pos.x) % 2 and int(pos.z) % 2:
		if not pos in removed_voxels:
			if !OPTIMIZE:
				args.variable_voxel_data[pos] = Vector3(1, 1, 1)
			else:
				var surrounding_voxels_square = Core.run(
					"chunk.geometry.can_be_seen", {
						position = pos, 
						voxel_data = args.voxel_data,
						square = true
					}).surrounding_voxels
				
				var surrounding_voxels = Core.run(
					"chunk.geometry.can_be_seen", {
						position = pos, 
						voxel_data = args.voxel_data
					}).surrounding_voxels
				
				if surrounding_voxels.size() != 6:
					args.variable_voxel_data[pos] = Vector3(1, 1, 1)
					for side in surrounding_voxels_square:
						if side.x >= 0 and side.y >= 0 and side.z >= 0:
							args.variable_voxel_data[pos] += side
							removed_voxels.append(pos+side)
				else:
					removed_voxels.append(pos)
	
	for voxel in removed_voxels:
		if args.variable_voxel_data.has(voxel):
			Core.emit_signal("msg", "Variable voxel data contained voxels that where supposed to be deleted!", Core.WARN, args)
	
	Core.emit_signal("msg", str(args.variable_voxel_data), Core.DEBUG, args)
	Core.emit_signal("msg", "Optimization returned " + str(args.variable_voxel_data.size()) + " voxel groups", Core.DEBUG, args)
# ^ chunk.optimize.optimize_voxels #############################################

# chunk.optimize.optimize_mesh #################################################
const optimize_mesh_meta := {
	func_name = "chunk.optimize.optimize_mesh",
	description = """
		handles text uvs and stuff
	""",
		mesh_data = [],
		voxel_data = {}}
static func optimize_mesh(args := optimize_mesh_meta) -> void: #################
	var mesh_data = Core.run(
		"chunk.optimize.optimize_vertices", {
			verts = args.mesh_data[Mesh.ARRAY_VERTEX],
			uvs = args.mesh_data[Mesh.ARRAY_TEX_UV],
			normals = args.mesh_data[Mesh.ARRAY_NORMAL],
			voxel_data = args.voxel_data
		})
	
	args.mesh_data[Mesh.ARRAY_VERTEX] = mesh_data.optimised_verts
	args.mesh_data[Mesh.ARRAY_TEX_UV] = mesh_data.optimised_uvs
	args.mesh_data[Mesh.ARRAY_NORMAL] = mesh_data.optimised_normals
# ^ chunk.optimize.optimize_mesh ###############################################


# chunk.optimize.optimize_vertices #############################################
const optimize_vertices_meta := {
	func_name = "chunk.optimize.optimize_vertices",
	description = """
		handles deleting and resizing verts
	""",
		verts = null,
		uvs = null,
		normals = null,
		optimised_verts = null,
		optimised_uvs = null,
		optimised_normals = null,
		voxel_data = {}}
static func optimize_vertices(args := optimize_vertices_meta) -> void: #########
	var optimised_verts := Array()
	var optimised_uvs := Array()
	var optimised_normals := Array()
	
	var deleted_verts := Array()
	
	var verts := Array(args.verts)
	var VSIZE = Core.scripts.chunk.geometry.VSIZE
	var i := 0
	for rect in verts.size()/6:
		var side = Vector3(0, VSIZE, 0)
		var count := 0
		for tri in 2:
			for vert in 3:
				if verts.has(verts[i] + side):
					count+=1
		i+=6
		print(count)
		var vsize
		if count < 3:
			vsize = VSIZE
			for del_vert in range(1, 6+1):
				if verts.has(i-del_vert):
					pass
					#deleted_verts.append(verts[i-del_vert]+Vector3(0, VSIZE, 0))
		else:
			vsize = 0
		
		if i >= verts.size() or deleted_verts.has(verts[i]):
			pass
		# X PLANE
		elif verts[i-1].x == verts[i-2].x and verts[i-2].x == verts[i-3].x:
			if args.normals[i-3] == Vector3(1, 0, 0):
				optimised_verts.append(verts[i-6])
				optimised_uvs.append(args.uvs[i-6])
				optimised_normals.append(args.normals[i-6])
				
				optimised_verts.append(verts[i-5] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-5])
				optimised_normals.append(args.normals[i-5])
				
				optimised_verts.append(verts[i-4] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-4])
				optimised_normals.append(args.normals[i-4])
				
				###
				
				optimised_verts.append(verts[i-3] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-3])
				optimised_normals.append(args.normals[i-3])
				
				optimised_verts.append(verts[i-2])
				optimised_uvs.append(args.uvs[i-2])
				optimised_normals.append(args.normals[i-2])
				
				optimised_verts.append(verts[i-1])
				optimised_uvs.append(args.uvs[i-1])
				optimised_normals.append(args.normals[i-1])
			else:
				optimised_verts.append(verts[i-6])
				optimised_uvs.append(args.uvs[i-6])
				optimised_normals.append(args.normals[i-6])
				
				optimised_verts.append(verts[i-5])
				optimised_uvs.append(args.uvs[i-5])
				optimised_normals.append(args.normals[i-5])
				
				optimised_verts.append(verts[i-4] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-4])
				optimised_normals.append(args.normals[i-4])
				
				###
				
				optimised_verts.append(verts[i-3] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-3])
				optimised_normals.append(args.normals[i-3])
				
				optimised_verts.append(verts[i-2] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-2])
				optimised_normals.append(args.normals[i-2])
				
				optimised_verts.append(verts[i-1])
				optimised_uvs.append(args.uvs[i-1])
				optimised_normals.append(args.normals[i-1])
		# Y PLANE
		elif verts[i-1].y == verts[i-2].y and verts[i-2].y == verts[i-3].y:
			if args.normals[i-3] == Vector3(0, 1, 0):
				optimised_verts.append(verts[i-6])
				optimised_uvs.append(args.uvs[i-6])
				optimised_normals.append(args.normals[i-6])
				
				optimised_verts.append(verts[i-5])
				optimised_uvs.append(args.uvs[i-5])
				optimised_normals.append(args.normals[i-5])
				
				optimised_verts.append(verts[i-4])
				optimised_uvs.append(args.uvs[i-4])
				optimised_normals.append(args.normals[i-4])
				
				###
				
				optimised_verts.append(verts[i-3])
				optimised_uvs.append(args.uvs[i-3])
				optimised_normals.append(args.normals[i-3])
				
				optimised_verts.append(verts[i-2])
				optimised_uvs.append(args.uvs[i-2])
				optimised_normals.append(args.normals[i-2])
				
				optimised_verts.append(verts[i-1])
				optimised_uvs.append(args.uvs[i-1])
				optimised_normals.append(args.normals[i-1])
			else:
				optimised_verts.append(verts[i-6])
				optimised_uvs.append(args.uvs[i-6])
				optimised_normals.append(args.normals[i-6])
				
				optimised_verts.append(verts[i-5])
				optimised_uvs.append(args.uvs[i-5])
				optimised_normals.append(args.normals[i-5])
				
				optimised_verts.append(verts[i-4])
				optimised_uvs.append(args.uvs[i-4])
				optimised_normals.append(args.normals[i-4])
				
				###
				
				optimised_verts.append(verts[i-3])
				optimised_uvs.append(args.uvs[i-3])
				optimised_normals.append(args.normals[i-3])
				
				optimised_verts.append(verts[i-2])
				optimised_uvs.append(args.uvs[i-2])
				optimised_normals.append(args.normals[i-2])
				
				optimised_verts.append(verts[i-1])
				optimised_uvs.append(args.uvs[i-1])
				optimised_normals.append(args.normals[i-1])
		# Z PLANE
		elif verts[i-1].z == verts[i-2].z and verts[i-2].z == verts[i-3].z:
			if args.normals[i-3] == Vector3(0, 0, 1):
				optimised_verts.append(verts[i-6])
				optimised_uvs.append(args.uvs[i-6])
				optimised_normals.append(args.normals[i-6])
				
				optimised_verts.append(verts[i-5])
				optimised_uvs.append(args.uvs[i-5])
				optimised_normals.append(args.normals[i-5])
				
				optimised_verts.append(verts[i-4] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-4])
				optimised_normals.append(args.normals[i-4])
				
				###
				
				optimised_verts.append(verts[i-3] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-3])
				optimised_normals.append(args.normals[i-3])
				
				optimised_verts.append(verts[i-2] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-2])
				optimised_normals.append(args.normals[i-2])
				
				optimised_verts.append(verts[i-1])
				optimised_uvs.append(args.uvs[i-1])
				optimised_normals.append(args.normals[i-1])
			else:
				optimised_verts.append(verts[i-6])
				optimised_uvs.append(args.uvs[i-6])
				optimised_normals.append(args.normals[i-6])
				
				optimised_verts.append(verts[i-5] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-5])
				optimised_normals.append(args.normals[i-5])
				
				optimised_verts.append(verts[i-4] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-4])
				optimised_normals.append(args.normals[i-4])
				
				###
				
				optimised_verts.append(verts[i-3] - Vector3(0, vsize, 0))
				optimised_uvs.append(args.uvs[i-3])
				optimised_normals.append(args.normals[i-3])
				
				optimised_verts.append(verts[i-2])
				optimised_uvs.append(args.uvs[i-2])
				optimised_normals.append(args.normals[i-2])
				
				optimised_verts.append(verts[i-1])
				optimised_uvs.append(args.uvs[i-1])
				optimised_normals.append(args.normals[i-1])
	
	args.optimised_verts = PoolVector3Array(optimised_verts)
	args.optimised_uvs = PoolVector2Array(optimised_uvs)
	args.optimised_normals = PoolVector3Array(optimised_normals)
	print(args.optimised_verts.size())
	
# chunk.optimize.optimize_vertices #############################################


# chunk.optimize.find_corner_pairs #############################################
const find_corner_pairs_meta := {
	func_name = "chunk.optimize.find_corner_pairs",
	description = """
		Finds the corners of planes (XX)
		XX-------|   XX-|
		|        |   |-XX
		|-------XX
	""",
		}
static func find_corner_pairs(vertices: PoolVector3Array, args := find_corner_pairs_meta) -> Array: 
	var edges0 = []
	var edges1 = []
	var edges2 = []
	
	var i = 0
	for _vert in vertices:
		var tri = [vertices[i], vertices[i+1], vertices[i+2]]
		var match_count = 0
		if not edges0.has(tri[0]):
			 match_count+=1
		if not edges1.has(tri[1]):
			match_count+=1
		if not edges2.has(tri[2]):
			match_count+=1
		if match_count >= 3:
			edges0.append(tri[0])
			edges1.append(tri[1])
			edges2.append(tri[2])
		i+=3
	
	return [edges0, edges1, edges2]
# ^ chunk.optimize.find_corner_pairs ###########################################
