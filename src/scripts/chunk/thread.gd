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
	
	if not Core.client.data.subsystem.chunk.Link.data.thread:
		Core.client.data.subsystem.chunk.Link.data.thread = Thread.new()
	
	var _data = {}
	var chunk_system = Core.client.data.subsystem.chunk.Link
	if MULTITHREADING:
		chunk_system.data.thread_busy = true
		var error: int = chunk_system.data.thread.start(chunk_system, "_chunk_thread_process", _data)
		if error:
			Core.emit_signal("msg", "Error starting chunk thread: " 
					+ str(error), Core.WARN, meta)
			chunk_system.data.thread_busy = false
			return
	else:
		Core.emit_signal("msg", "Multithreading has been turnend off, game will be very slow when loading chunks!", Core.WARN, meta)
		Core.Client.data.subsystem.chunk.Link._chunk_thread_process()

# once per thread ##############################################################
static func discover_surrounding_chunks(): #####################################
	if !Core.world.has_node("Chunk"):
		return false
	
	var player_path = "Input/" + Core.client.data.subsystem.input.Link.data.player
	if !Core.world.has_node(player_path):
		return false
	var player = Core.world.get_node(player_path)
	var center_chunk = Core.scripts.chunk.tools.get_chunk(player.get_node("Player").translation)
	var distance = player.components.render_distance
	
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
		#if !Core.client.data.chunk_index.has(chunk):
			#chunks_to_create.append(chunk)
		#print(str(chunk))
		if !Core.world.get_node("Chunk").has_node(str(chunk)):
			chunks_to_create.append(chunk)
	
	#for chunk in Core.world.get_node("Chunk").get_children():
		#if not chunk.components.position.world in surrounding_chunks:
			#Core.scripts.chunk.manager.destroy_chunk(chunk)
	
	var player_name = Core.client.data.subsystem.input.Link.data.player
	var min_distance = Core.world.get_node("Input/" + player_name).components.render_distance + 500
	var closest_chunk = false
	
	#var woah = center_chunk.distance_to(Vector3(0, 0, 0))
	#Core.emit_signal("msg", "surrounding_chunks " + str(surrounding_chunks), Core.DEBUG, meta)
	#Core.emit_signal("msg", "Chunks to create " + str(chunks_to_create), Core.DEBUG, meta)
	
	for chunk in chunks_to_create:
		if center_chunk.distance_to(chunk) < min_distance:
			min_distance = center_chunk.distance_to(chunk)
			closest_chunk = chunk
	
	if closest_chunk:
		#Core.emit_signal("msg", "Creating closest chunk " + str(closest_chunk), Core.DEBUG, meta)
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
	node.get_node("Chunk/MeshInstance").mesh = null
	node.get_node("Chunk/MeshInstance/StaticBody/Shape").shape = null
	#if Core.client.data.subsystem.chunk.Link.data.mem_max:
		#return
	#Core.emit_signal("msg", "Compiling chunk...", Core.TRACE, meta)
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
	
	var full_mesh = PoolVector3Array()
	var i = 0
	for position in node.components.mesh.blocks.keys():
		#var start = OS.get_ticks_msec()
		if node.components.mesh.blocks_loaded >= BLOCK_LIMIT:
			Core.emit_signal("msg", "Chunk contained more then " + str(BLOCK_LIMIT) + " blocks!", Core.ERROR, meta)
			break
		
		var voxel_data = Dictionary()
		if node.components.mesh.blocks[position].has("voxels"):
			voxel_data = node.components.mesh.blocks[position].voxels
		else:
			Core.emit_signal("msg", "Block did not contain any voxels!", Core.WARN, meta)
			break
		
		var voxel_mesh = Core.lib.voxel.new()
		#var start2 = OS.get_ticks_msec()
		var mesh_arrays = voxel_mesh.create_cube(position+Vector3(0, -1, 0), 
			voxel_data.keys(), voxel_data)
		#Core.emit_signal("msg", "voxel_mesh(per block) took " + str(OS.get_ticks_msec()-start2) + "ms", Core.TRACE, meta)
		
		voxel_mesh.free()
		
		var mesh
		if node.get_node("Chunk/MeshInstance").mesh:
			mesh = node.get_node("Chunk/MeshInstance").mesh
		else:
			mesh = ArrayMesh.new()
		
		if mesh_arrays[Mesh.ARRAY_VERTEX].size() > 0:
			mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)
			mesh.surface_set_material(i, mat)
			i += 1
			full_mesh.append_array(mesh_arrays[Mesh.ARRAY_VERTEX])
			
			node.get_node("Chunk/MeshInstance").mesh = mesh
			#node.components.mesh.blocks_loaded += 1
			#Core.client.data.blocks_loaded += 1
		
		#Core.emit_signal("msg", "compile(per block) took " + str(OS.get_ticks_msec()-start) + "ms", Core.TRACE, meta)
	if !full_mesh.size() > 0:
		node.get_node("Chunk/MeshInstance").mesh = null
		node.get_node("Chunk/MeshInstance/StaticBody/Shape").shape = null
	# VERY SLOW (for some reason, thats why it's only in chunk completion)
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(0, 0, 255))
	var shape := ConcavePolygonShape.new()
	shape.set_faces(full_mesh)
	node.get_node("Chunk/MeshInstance/StaticBody/Shape").shape = shape
	# /VERY SLOW
	#Core.emit_signal("msg", "Finished compiling!", Core.DEBUG, meta)

# once per thread ##############################################################
static func process_chunks(): ##################################################
	#Core.emit_signal("msg", "Processing chunks...", Core.TRACE, meta)
	if !Core.scripts.core.manager.get_entities_with("Chunk"):
		Core.emit_signal("msg", "No chunks where found!", Core.TRACE, meta)
		return false
	for node in Core.scripts.core.manager.get_entities_with("Chunk"):
		#Core.emit_signal("msg", "Checking rendered state..." + str(node.components.mesh), Core.TRACE, meta)
		if node.components.mesh.rendered == false:
			update_pending_blocks(node)

# once per chunk ###############################################################
static func update_pending_blocks(node: Entity): ###############################
	# Returns blocks_loaded, mesh, vertex_data
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(255, 0, 0))
	compile(node)
	node.components.mesh.rendered = true
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(0, 0, 0))


#VoxelTerrain._precalculate_priority_positions()
#VoxelTerrain._precalculate_neighboring()
#VoxelTerrain._update_pending_blocks()


# Creates one surrounding chunk per call
