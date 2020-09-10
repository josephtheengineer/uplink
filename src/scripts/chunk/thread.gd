#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.thread",
	description = """
		
	"""
}

const MULTITHREADING = true
const BLOCK_LIMIT = 16*16*16

static func start_chunk_thread(): #####################################################
	var userdata = {}
	var player_path = "World/Inputs/" + Core.Client.data.subsystem.input.Link.data.player
	if !Core.get_parent().has_node(player_path):
		return false
	
	var player = Core.get_parent().get_node(player_path)
	userdata.player_position = player.get_node("Player").translation
	userdata.render_distance = player.components.render_distance
	userdata.chunks = Core.scripts.core.manager.get_entities_with("Chunks")
	if !userdata.chunks:
		return
	#Core.emit_signal("msg", "Starting chunk thread...", Core.DEBUG, meta)
	Core.Client.data.subsystem.chunk.Link.data.thread_busy = true
	if not Core.Client.data.subsystem.chunk.Link.data.thread:
		Core.Client.data.subsystem.chunk.Link.data.thread = Thread.new()
	
	if MULTITHREADING:
		var error: int = Core.Client.data.subsystem.chunk.Link.data.thread.start(Core.Client.data.subsystem.chunk.Link, "_chunk_thread_process", userdata)
		if error:
			Core.emit_signal("msg", "Error starting chunk thread: " 
			+ str(error), Core.WARN, meta)
			Core.Client.data.subsystem.chunk.Link.data.thread_busy = false
	else:
		Core.emit_signal("msg", "Multithreading has been turnend off, game will be very slow when loading chunks!", Core.WARN, meta)
		Core.Client.data.subsystem.chunk.Link._chunk_thread_process(userdata)


static func process_chunks(chunks: Array): #######################################
	if !chunks:
		return false
	for node in chunks:
		if node.components.size() != 0:
			if node.components.rendered == false:
				_process_chunk(node)


static func _process_chunk(node): #############################################
	var chunk = Spatial.new()
	chunk.name = "Chunk"
	
	if !node.components.block_data:
		var pos = node.components.position
		chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
		node.components.rendered = true
		Core.Client.data.chunk_index.append(pos)
		return
	
	# Returns blocks_loaded, mesh, vertex_data
	var chunk_data = compile(node.components.block_data, 
		Core.scripts.eden.block_data.blocks()) 
	
	var mesh_instance = MeshInstance.new()
	mesh_instance.name = "MeshInstance"
	chunk.add_child(mesh_instance)
	mesh_instance.mesh = chunk_data.mesh
	
	var body = StaticBody.new()
	body.name = "StaticBody"
	mesh_instance.add_child(body)
	
	#var units = 1
	#mesh_instance.scale = Vector3(0.063, 0.063, 0.063)
	
	var collision_shape = CollisionShape.new()
	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	collision_shape.name = "CollisionShape"
	collision_shape.shape = shape
	body.add_child(collision_shape)
	
	Core.Client.data.blocks_found += node.components.block_data.size()
	Core.Client.data.blocks_loaded += chunk_data.blocks_loaded
	
	var pos = node.components.position
	chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
	node.components.rendered = true
	Core.Client.data.chunk_index.append(pos)
	
	node.call_deferred("add_child", chunk)
	
	if node.components.object != null or node.components.method != null:
		var error = Core.connect("rendered", node.components.object, node.components.method)
		if error:
			Core.emit_signal("msg", "Error on binding to rendered signal on chunk: " + str(error), Core.WARN, meta)
		Core.emit_signal("rendered")


#VoxelTerrain._precalculate_priority_positions()
#VoxelTerrain._precalculate_neighboring()
#VoxelTerrain._update_pending_blocks()


# Creates one surrounding chunk per call
static func discover_surrounding_chunks(center_chunk: Vector3, distance: int): ########
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


# Returns blocks_loaded, mesh, vertex_data
static func compile(block_data: Dictionary, materials: Dictionary): ########################
	var blocks_loaded = 0
	Core.emit_signal("msg", "Compiling chunk...", Core.TRACE, meta)
	#var mesh
	var vertex_data = []
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
	
	var mesh = SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	mesh.set_material(mat)
	
	var VSIZE = Core.scripts.chunk.geometry.VSIZE
	
	var voxel_data = Dictionary()
	# draw an outline of voxels (for debuging mostly)
	for x in 16:
		for y in 16:
			for z in 16:
				if x == 0 and y == 0 or x == 0 and z == 0 or z == 0 and y == 0:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
				elif x == 15 and y == 15 or x == 15 and z == 15 or z == 15 and y == 15:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
				elif x == 15 and y == 0 or x == 15 and z == 0 or z == 15 and y == 0:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
				elif x == 0 and y == 15 or x == 0 and z == 15 or z == 0 and y == 15:
					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
	
	for position in block_data.keys():
		if blocks_loaded >= BLOCK_LIMIT:
			Core.emit_signal("msg", "Chunk contained more then " + str(BLOCK_LIMIT) + " blocks!", Core.ERROR, meta)
			break
		#if Core.scripts.chunk.geometry.can_be_seen(position, block_data).size() != 6:
		#Core.emit_signal("msg", "Creating cube...", Core.TRACE, meta)
		var cube_data = Core.scripts.chunk.geometry.create_cube(position, 
			voxel_data, mesh, block_data) # Returns mesh, vertex_data
		
		#mesh = cube_data.mesh
		vertex_data += cube_data.vertex_data
		blocks_loaded += 1
	
	Core.emit_signal("msg", "Finished compiling!", Core.DEBUG, meta)
	return {"blocks_loaded" : blocks_loaded, "mesh" : mesh.commit(), "vertex_data" : 
		vertex_data}
