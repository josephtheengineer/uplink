#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.thread",
	description = """
		
	"""
}

const MULTITHREADING = true
const BLOCK_LIMIT = 16*16*16

# chunk.thread.start_discover_thread ###########################################
const start_discover_thread_meta := {
	func_name = "chunk.thread.start_discover_thread",
	description = """
		once per thread
	""",
		}
static func start_discover_thread(args := start_discover_thread_meta) -> void: ########
	if not Core.client.data.subsystem.chunk.Link.data.discover.thread:
		Core.client.data.subsystem.chunk.Link.data.discover.thread = Thread.new()
	
	var _data = {}
	var chunk_system = Core.client.data.subsystem.chunk.Link
	if MULTITHREADING:
		chunk_system.data.discover.busy = true
		var error: int = chunk_system.data.discover.thread.start(chunk_system, "_discover_surrounding_chunks")
		if error:
			Core.emit_signal("msg", "Error starting chunk thread: " 
					+ str(error), Core.WARN, args)
			chunk_system.data.discover.busy = false
			return
	else:
		discover_surrounding_chunks()
# ^ chunk.thread.start_discover_thread #########################################


# chunk.thread.start_process_thread ############################################
const start_process_thread_meta := {
	func_name = "chunk.thread.start_process_thread",
	description = """
		once per thread
	""",
		}
static func start_process_thread(args := start_process_thread_meta) -> void: ###
	if not Core.client.data.subsystem.chunk.Link.data.process.thread:
		Core.client.data.subsystem.chunk.Link.data.process.thread = Thread.new()
	
	var _data = {}
	var chunk_system = Core.client.data.subsystem.chunk.Link
	if MULTITHREADING:
		chunk_system.data.process.busy = true
		var error: int = chunk_system.data.process.thread.start(chunk_system, "_process_chunks")
		if error:
			Core.emit_signal("msg", "Error starting chunk thread: " 
					+ str(error), Core.WARN, args)
			chunk_system.data.process.busy = false
			return
	else:
		process_chunks()
# ^ chunk.thread.start_process_thread ##########################################


# chunk.thread.discover_surrounding_chunks #####################################
const discover_surrounding_chunks_meta := {
	func_name = "chunk.thread.discover_surrounding_chunks",
	description = """
		once per thread
	""",
		}
static func discover_surrounding_chunks(args := discover_surrounding_chunks_meta) -> bool: 
	if !Core.world.has_node("Chunk"):
		return false
	
	var player_path = "Input/" + Core.client.data.subsystem.input.Link.data.player
	if !Core.world.has_node(player_path):
		return false
	var player = Core.world.get_node(player_path)
	var center_chunk = Core.scripts.chunk.tools.get_chunk(player.get_node("Player").translation)
	var distance = player.components.render_distance
	
	var surrounding_chunks = []
	
	for x in range(center_chunk.x - distance, center_chunk.x + distance):
		for y in range(center_chunk.y - distance, center_chunk.y + distance):
			for z in range(center_chunk.z - distance, center_chunk.z + distance):
				surrounding_chunks.append(Vector3(x, y, z))
	
	for chunk in surrounding_chunks:
		if !Core.world.has_node("Chunk/" + str(chunk)):
			#Core.scripts.chunk.manager.draw_chunk_highlight(chunk, Color(255, 255, 255))
			Core.scripts.chunk.manager.create_chunk(chunk)
	
	for chunk in Core.world.get_node("Chunk").get_children():
		if not surrounding_chunks.has(chunk.components.position.world):
			Core.scripts.chunk.manager.destroy_chunk(chunk)
		else:
			pass
			#Core.scripts.chunk.manager.draw_chunk_highlight(chunk, Color(0, 1, 0))
	return true
# ^ chunk.thread.discover_surrounding_chunks ###################################


# chunk.thread.compile #########################################################
const compile_meta := {
	func_name = "chunk.thread.compile",
	description = """
		once per chunk
	""",
		}
static func compile(node: Entity, args := compile_meta) -> void: ###############
	var mesh_instance: MeshInstance = node.get_node("Chunk/MeshInstance")
	mesh_instance.mesh = null
	
	var shape: CollisionShape = node.get_node("Chunk/MeshInstance/StaticBody/Shape")
	shape.shape = null
	
	var mat = create_atlas()
	
	var full_mesh = PoolVector3Array()
	for position in node.components.mesh.blocks.keys():
		if node.components.mesh.blocks_loaded >= BLOCK_LIMIT:
			Core.emit_signal("msg", "Chunk contained more then " + str(BLOCK_LIMIT) + " blocks!", Core.ERROR, args)
			#break
		
		var surrounding_blocks = Core.run(
			"chunk.geometry.block_can_be_seen", {
				position = position, 
				block_data = node.components.mesh.blocks.keys()
			}).surrounding_blocks
		
		if surrounding_blocks.size() != 6:
			Core.scripts.chunk.manager.draw_block_highlight(node, position, Color(255, 255, 255))
		var mesh_arrays := create_cube_mesh(node, position)
		add_verts_to_chunk(node, mesh_arrays, mat)
		full_mesh.append_array(mesh_arrays[Mesh.ARRAY_VERTEX])
	
	create_chunk_shape(node, full_mesh)
	
	var empty_points := 0
	for point in full_mesh:
		if point == Vector3(0, 0, 0):
			empty_points+=1
	Core.emit_signal("msg", "Verts: " + str(full_mesh.size()), Core.INFO, args)
	Core.emit_signal("msg", "Empty points: " + str(empty_points), Core.INFO, args)
# ^ chunk.thread.compile #######################################################


# chunk.thread.create_chunk_shape ##############################################
const create_chunk_shape_meta := {
	func_name = "chunk.thread.create_chunk_shape",
	description = """
		
	""",
		}
static func create_chunk_shape(node: Entity, full_mesh: PoolVector3Array, args := create_chunk_shape_meta) -> void: 
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(0, 0, 255))
	var shape := ConcavePolygonShape.new()
	shape.set_faces(full_mesh)
	if !node:
		return
	var shape_node: CollisionShape = node.get_node("Chunk/MeshInstance/StaticBody/Shape")
	shape_node.shape = shape
# ^ chunk.thread.create_chunk_shape ############################################


# chunk.thread.create_cube_mesh ################################################
const create_cube_mesh_meta := {
	func_name = "chunk.thread.create_cube_mesh",
	description = """
		
	""",
		}
static func create_cube_mesh(node: Entity, position: Vector3, args := create_cube_mesh_meta) -> Array: 
	var voxel_data = Dictionary()
	voxel_data = Core.run("chunk.generator.generate_block").data
	
	var mesh_arrays = Core.run("chunk.geometry.create_cube", {
		position = position+Vector3(0, -1, 0),
		voxel_data = voxel_data
	}).mesh
	
	return mesh_arrays
# ^ chunk.thread.create_cube_mesh ##############################################


# chunk.thread.add_verts_to_chunk ##############################################
const add_verts_to_chunk_meta := {
	func_name = "chunk.thread.add_verts_to_chunk",
	description = """
		
	""",
		}
static func add_verts_to_chunk(node: Entity, mesh_arrays: Array, mat: SpatialMaterial, args := add_verts_to_chunk_meta) -> void: 
	var mesh = ArrayMesh.new()
	if !node:
		return
	var mesh_node: MeshInstance = node.get_node("Chunk/MeshInstance")
	if node and mesh_node.mesh:
		mesh = mesh_node.mesh
	else:
		mesh = ArrayMesh.new()
	
	if mesh_arrays[Mesh.ARRAY_VERTEX].size() > 0:
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)
		mesh.surface_set_material(0, mat)
		
		mesh_node.mesh = mesh
		node.components.mesh.blocks_loaded += 1
		Core.client.data.blocks_loaded += 1
	else:
		Core.emit_signal("msg", "Mesh arrays contained no verts!", Core.WARN, args)
# ^ chunk.thread.add_verts_to_chunk ############################################


# chunk.thread.create_atlas ####################################################
const create_atlas_meta := {
	func_name = "chunk.thread.create_atlas",
	description = """
		
	""",
		}
static func create_atlas(args := create_atlas_meta) -> SpatialMaterial: ########
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
	return mat
# ^ chunk.thread.create_atlas ##################################################


# chunk.thread.process_chunks ##################################################
const process_chunks_meta := {
	func_name = "chunk.thread.process_chunks",
	description = """
		once per thread
	""",
		}
static func process_chunks(args := process_chunks_meta) -> bool: ###############
	#Core.emit_signal("msg", "Processing chunks...", Core.TRACE, args)
	if !Core.scripts.core.manager.get_entities_with("Chunk"):
		Core.emit_signal("msg", "No chunks where found!", Core.TRACE, args)
		return false
	for node in Core.scripts.core.manager.get_entities_with("Chunk"):
		#Core.emit_signal("msg", "Checking rendered state..." + str(node.components.mesh), Core.TRACE, args)
		if node and node.components.mesh.rendered == false: # and node.components.meta.in_range: # and node.components.mesh.detailed:
			update_pending_blocks(node)
	return true
# ^ chunk.thread.process_chunks ################################################


# chunk.thread.update_pending_blocks ###########################################
const update_pending_blocks_meta := {
	func_name = "chunk.thread.update_pending_blocks",
	description = """
		once per chunk
	""",
		}
static func update_pending_blocks(node: Entity, args := update_pending_blocks_meta) -> void: 
	if !node:
		return
	# Returns blocks_loaded, mesh, vertex_data
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(255, 0, 0))
	compile(node)
	if !node:
		return
	node.components.mesh.rendered = true
	Core.scripts.chunk.manager.draw_chunk_highlight(node, Color(0, 0, 0))
# ^ chunk.thread.update_pending_blocks #########################################
