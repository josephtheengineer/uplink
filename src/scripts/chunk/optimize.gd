#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.optimize",
	description = """
		optimizes mesh data
	"""
}

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
				args.variable_voxel_data[pos] = Vector3(0, 0, 0)
				for side in surrounding_voxels_square:
					if side.x >= 0 and side.y >= 0 and side.z >= 0:
						args.variable_voxel_data[pos] += side
						removed_voxels.append(pos+side)
			else:
				removed_voxels.append(pos)
	
	for voxel in removed_voxels:
		if args.variable_voxel_data.has(voxel):
			Core.emit_signal("msg", "dead", Core.FATAL, args)
	
	Core.emit_signal("msg", str(args.variable_voxel_data), Core.DEBUG, args)
	Core.emit_signal("msg", "Optimization returned " + str(args.variable_voxel_data.size()) + " voxel groups", Core.DEBUG, args)
# ^ chunk.optimize.optimize_voxels #############################################

# chunk.optimize.optimize_mesh #################################################
const optimize_mesh_meta := {
	func_name = "chunk.optimize.optimize_mesh",
	description = """
		handles text uvs and stuff
	""",
		}
static func optimize_mesh(mesh_data: Array, args := optimize_mesh_meta) -> void: 
	optimize_vertices(mesh_data[Mesh.ARRAY_VERTEX])
# ^ chunk.optimize.optimize_mesh ###############################################


# chunk.optimize.optimize_vertices #############################################
const optimize_vertices_meta := {
	func_name = "chunk.optimize.optimize_vertices",
	description = """
		handles deleting and resizing verts
	""",
		}
static func optimize_vertices(verts: PoolVector3Array, args := optimize_vertices_meta) -> PoolVector3Array: 
	var i := 0
	var corner := find_corner_pairs(verts)
	
	return verts
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
