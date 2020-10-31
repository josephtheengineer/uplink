#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.optimize",
	description = """
		optimizes mesh data
	"""
}


# This function handles text uvs and stuff
static func optimize_mesh(mesh_data: Array):
	optimize_vertices(mesh_data[Mesh.ARRAY_VERTEX])


# This function handles deleting and resizing verts
static func optimize_vertices(verts: PoolVector3Array) -> PoolVector3Array:
	var i := 0
	var corner := find_corner_pairs(verts)
	
	return verts


# Finds the corners of planes (XX)
# XX-------|   XX-|
# |        |   |-XX
# |-------XX
static func find_corner_pairs(vertices: PoolVector3Array) -> Array:
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
