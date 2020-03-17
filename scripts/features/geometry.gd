var script_name = "geometry"

const surrounding_blocks = [ Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0) ]

func can_be_seen(position, block_data):
	var num_surrounding_blocks = [ ]
	
	for surrounding_position in surrounding_blocks:
		if block_data.has(position + surrounding_position):
			num_surrounding_blocks.append(surrounding_position)
	return num_surrounding_blocks

func create_cube(position, id, mesh, materials, block_data):
	var vertex_data = []
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(materials[id])
	
	var sides_not_to_render = can_be_seen(position, block_data)
	
	if !sides_not_to_render.has(Vector3(0, -1, 0)):
		vertex_data += create_horizontal_plane(st, position + Vector3(0, -1, 0), "down")
	
	if !sides_not_to_render.has(Vector3(0, 1, 0)): 
		vertex_data += create_horizontal_plane(st, position + Vector3(0, 0, 0), "up")
	
	
	
	if !sides_not_to_render.has(Vector3(0, 0, 1)):
		vertex_data += create_vertical_plane(st, position + Vector3(0, 0, 1), "west")
	
	if !sides_not_to_render.has(Vector3(0, 0, -1)):
		vertex_data += create_vertical_plane(st, position + Vector3(0, 0, 0), "east")
	
	if !sides_not_to_render.has(Vector3(-1, 0, 0)):
		vertex_data += create_vertical_plane(st, position + Vector3(0, 0, 0), "north")
	
	if !sides_not_to_render.has(Vector3(1, 0, 0)):
		vertex_data += create_vertical_plane(st, position + Vector3(1, 0, 0), "south")
	
	return { "mesh" : st.commit(mesh), "vertex_data" : vertex_data }

const vertical_plane_uvs = [ Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), Vector2(1, 1) ]
const vertical_plane_vertices = [ Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(1, -1, 0), Vector3(0, -1, 0), Vector3(1, 0, 0) ]

const vertical_plane_uvs2 = [ Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), Vector2(1, 1) ]
const vertical_plane_vertices2 = [ Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, -1, 1), Vector3(0, -1, 0), Vector3(0, 0, 1) ]

func create_vertical_plane(st, position, direction):
	var vertex_data = []
	if direction == "west":
		for i in range(vertical_plane_vertices.size()):
			st.add_uv(vertical_plane_uvs[i])
			st.add_vertex(vertical_plane_vertices[i] + position)
			vertex_data.append(vertical_plane_vertices[i] + position)
		
	elif direction == "east":
		vertical_plane_vertices.invert()
		vertical_plane_uvs.invert()
		for i in range(vertical_plane_vertices.size()):
			st.add_uv(vertical_plane_uvs[i])
			st.add_vertex(vertical_plane_vertices[i] + position)
			vertex_data.append(vertical_plane_vertices[i] + position)
		
		vertical_plane_vertices.invert()
		vertical_plane_uvs.invert()
	
	
	
	elif direction == "north":
		for i in range(vertical_plane_vertices2.size()):
			st.add_uv(vertical_plane_uvs2[i])
			st.add_vertex(vertical_plane_vertices2[i] + position)
			vertex_data.append(vertical_plane_vertices2[i] + position)
	
	elif direction == "south":
		vertical_plane_vertices2.invert()
		vertical_plane_uvs2.invert()
		for i in range(vertical_plane_vertices2.size()):
			st.add_uv(vertical_plane_uvs2[i])
			st.add_vertex(vertical_plane_vertices2[i] + position)
			vertex_data.append(vertical_plane_vertices2[i] + position)
		
		vertical_plane_vertices2.invert()
		vertical_plane_uvs2.invert()
	return vertex_data

const horizontal_plane_uvs = [ Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(0, 1), Vector2(1, 0) ]
const horizontal_plane_vertices = [ Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(0, 0, 1), Vector3(1, 0, 0) ]

func create_horizontal_plane(st, position, direction):
	var vertex_data = []
	if direction == "up":
		for i in range(horizontal_plane_vertices.size()):
			st.add_uv(horizontal_plane_uvs[i])
			st.add_vertex(horizontal_plane_vertices[i] + position)
			vertex_data.append(horizontal_plane_vertices[i] + position)
		
	elif direction == "down":
		horizontal_plane_vertices.invert()
		horizontal_plane_uvs.invert()
		for i in range(horizontal_plane_vertices.size()):
			st.add_uv(horizontal_plane_uvs[i])
			st.add_vertex(horizontal_plane_vertices[i] + position)
			vertex_data.append(horizontal_plane_vertices[i] + position)
		
		horizontal_plane_vertices.invert()
		horizontal_plane_uvs.invert()
	return vertex_data