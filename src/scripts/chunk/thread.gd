#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.thread",
	description = """
		
	"""
}

const MULTITHREADING = true
const BLOCK_LIMIT = 16*16*16

# once per thread ##############################################################
static func start_chunk_thread(): ##############################################
	#Core.emit_signal("msg", "Starting chunk thread...", Core.TRACE, meta)
	# the chunk process requires player data and other settings
	var thread_data = {}
	var player_path = "World/Inputs/" + Core.Client.data.subsystem.input.Link.data.player
	if !Core.get_parent().has_node(player_path):
		return false
	
	var player = Core.get_parent().get_node(player_path)
	thread_data.player_position = player.get_node("Player").translation
	thread_data.render_distance = player.components.render_distance
	thread_data.chunks = Core.scripts.core.manager.get_entities_with("Chunks")
	if !thread_data.chunks:
		return
	
	if not Core.Client.data.subsystem.chunk.Link.data.thread:
		Core.Client.data.subsystem.chunk.Link.data.thread = Thread.new()
	
	var chunk_system = Core.Client.data.subsystem.chunk.Link
	if MULTITHREADING:
		chunk_system.data.thread_busy = true
		var error: int = chunk_system.data.thread.start(chunk_system, "_chunk_thread_process", thread_data)
		if error:
			Core.emit_signal("msg", "Error starting chunk thread: " 
			+ str(error), Core.WARN, meta)
			chunk_system.data.thread_busy = false
			return
	else:
		Core.emit_signal("msg", "Multithreading has been turnend off, game will be very slow when loading chunks!", Core.WARN, meta)
		Core.Client.data.subsystem.chunk.Link._chunk_thread_process(thread_data)

# once per thread ##############################################################
static func discover_surrounding_chunks(center_chunk: Vector3, distance: int): #
	var surrounding_chunks = []
	
	var top = center_chunk.x - distance;
	var bottom = top + distance * 2;
	
	var front = center_chunk.y - distance;
	var back = front + distance * 2;
	
	var left = center_chunk.z - distance;
	var right = left + distance * 2;
	
	for x in range(top, bottom):
		for y in range(front, back):
			for z in range(left, right):
				var dx = x - center_chunk.x
				var dy = y - center_chunk.y
				var dz = z - center_chunk.z
				var distance_squared = dx * dx + dy * dy + dz * dz
				
				if distance_squared <= (distance * distance):
					surrounding_chunks.append(
						Vector3(x, y, z))
	
	var chunks_to_create = []
	
	for chunk in surrounding_chunks:
		if !Core.Client.data.chunk_index.has(chunk):
			chunks_to_create.append(chunk)
	
	var player_name = Core.Client.data.subsystem.input.Link.data.player
	var min_distance = Core.get_parent().get_node("World/Inputs/" + player_name).components.render_distance + 500
	var closest_chunk = Vector3()
	
	#var woah = center_chunk.distance_to(Vector3(0, 0, 0))
	
	for chunk in chunks_to_create:
		if center_chunk.distance_to(chunk) < min_distance:
			min_distance = center_chunk.distance_to(chunk)
			closest_chunk = chunk
	
	if closest_chunk != Vector3(0, 0, 0):
		return Core.scripts.chunk.manager.create_chunk(closest_chunk)
	
#	# Remove chunks outside of bounds
#	var entities = Entity.get_entities_with("chunk")
#	for id in entities:
#		var pos = Entity.get_component(id, "chunk.position")
#		if !surrounding_chunks.has(pos):
#			Core.Client.chunk_index.erase(pos)
#			if Entity.get_component(id, "chunk.blocks_loaded"):
#				Core.Client.blocks_loaded -= Entity.get_component(id, "chunk.blocks_loaded")
#				Core.Client.blocks_found -= Entity.get_component(id, "chunk.block_data").size()
#			Core.emit_signal("msg", "Destroyed chunk" + str(pos), Core.DEBUG, meta)
#			Entity.destory(id)

# once per chunk ###############################################################
static func compile(node: Entity): #############################################
	if Core.Client.data.subsystem.chunk.Link.data.mem_max:
		return
	var blocks_loaded = 0
	Core.emit_signal("msg", "Compiling chunk...", Core.TRACE, meta)
	#var mesh
	#var block_data_ext = block_data
	
	#mat.albedo_color = Color(1, 0, 0, 1)
	
	# create atlas
	var image_texture = ImageTexture.new()
	var dynamic_image = Image.new()
	
	var data = PoolByteArray()
	for x in 2:
		for y in 2:
			if x == 0 and y == 0:
				data.append(100)
				data.append(100)
				data.append(255)
			else:
				data.append(0)
				data.append(0)
				data.append(0)
	
	dynamic_image.create_from_data(2, 2, false, Image.FORMAT_RGB8, data)
	#dynamic_image.fill(Color(0, 0, 1))
	image_texture.create_from_image(dynamic_image)
	
	var mat = SpatialMaterial.new()
	mat.albedo_texture = image_texture
	
	var VSIZE = Core.scripts.chunk.geometry.VSIZE
	
	var voxel_data = Dictionary()
	# draw an outline of voxels (for debuging mostly)
#	for x in 16:
#		for y in 16:
#			for z in 16:
#				if x == 0 and y == 0 or x == 0 and z == 0 or z == 0 and y == 0:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 15 and y == 15 or x == 15 and z == 15 or z == 15 and y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 15 and y == 0 or x == 15 and z == 0 or z == 15 and y == 0:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 0 and y == 15 or x == 0 and z == 15 or z == 0 and y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
	for x in 16:
		for y in 16:
			for z in 16:
				if x == 0:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
				elif z == 0:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
				elif y == 0:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
				elif x == 15:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
				elif y == 15:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
	
	var full_mesh = PoolVector3Array()
	
	for position in node.components.block_data.keys():
		#var start = OS.get_ticks_msec()
		if blocks_loaded >= BLOCK_LIMIT:
			Core.emit_signal("msg", "Chunk contained more then " + str(BLOCK_LIMIT) + " blocks!", Core.ERROR, meta)
			break
		
		var voxel_mesh = Core.VoxelMesh.new()
		
		var mesh_arrays = voxel_mesh.create_cube(position, 
			voxel_data.keys(), voxel_data)
		
		voxel_mesh.free()
		
		
		var mesh
		if node.get_node("Chunk/MeshInstance").mesh:
			mesh = node.get_node("Chunk/MeshInstance").mesh
		else:
			mesh = ArrayMesh.new()
		
		if mesh_arrays[Mesh.ARRAY_VERTEX].size() > 0:
			mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)
			mesh.surface_set_material(blocks_loaded, mat)
			full_mesh.append_array(mesh_arrays[Mesh.ARRAY_VERTEX])
		
		node.get_node("Chunk/MeshInstance").mesh = mesh
		blocks_loaded += 1
		Core.Client.data.blocks_loaded += 1
		
		#Core.emit_signal("msg", "compile(per block) took " + str(OS.get_ticks_msec()-start) + "ms", Core.TRACE, meta)
	# VERY SLOW (for some reason, thats why it's only in chunk completion)
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(0, 0, 255))
	var shape := ConcavePolygonShape.new()
	shape.set_faces(full_mesh)
	node.get_node("Chunk/MeshInstance/StaticBody/Shape").shape = shape
	# /VERY SLOW
	Core.emit_signal("msg", "Finished compiling!", Core.DEBUG, meta)

# once per thread ##############################################################
static func process_chunks(chunks: Array): #####################################
	if !chunks:
		Core.emit_signal("msg", "No chunks where provided to the chunk thread!", Core.WARN, meta)
		return false
	for node in chunks:
		if node.components.rendered == false:
			update_pending_blocks(node)

# once per chunk ###############################################################
static func update_pending_blocks(node: Entity): ###############################
	# Returns blocks_loaded, mesh, vertex_data
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(255, 0, 0))
	compile(node)
	node.components.rendered = true
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(0, 0, 0))


#VoxelTerrain._precalculate_priority_positions()
#VoxelTerrain._precalculate_neighboring()
#VoxelTerrain._update_pending_blocks()


# Creates one surrounding chunk per call
