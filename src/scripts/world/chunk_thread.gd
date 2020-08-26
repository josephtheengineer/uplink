#warning-ignore:unused_class_variable
const script_name := "chunk_thread"

var Debug := preload("res://src/scripts/debug/debug.gd").new()
var Manager := preload("res://src/scripts/manager/manager.gd").new()
var ChunkTools := preload("res://src/scripts/world/chunk_tools.gd").new()
var ChunkManager := preload("res://src/scripts/world/chunk_manager.gd").new()
var BlockData := preload("res://src/scripts/eden/block_data.gd").new()
var Geometry := preload("res://src/scripts/world/geometry.gd").new()

var _chunk_thread := Thread.new()
var _chunk_thread_busy := false

func start_chunk_thread(): #####################################################
	var userdata = {}
	var player_path = "World/Inputs/JosephTheEngineer/Player"
	if !Core.get_parent().has_node(player_path):
		return false
	
	var player = Core.get_parent().get_node(player_path)
	userdata.player_position = player.translation
	userdata.render_distance = Core.Client.render_distance
	userdata.chunks = Manager.get_entities_with("Chunks")
	#Core.emit_signal("msg", "Starting chunk thread...", Debug.DEBUG, self)
	_chunk_thread_busy = true
	var error := _chunk_thread.start(self, "_chunk_thread_process", userdata)
	if error:
		emit_signal("msg", "Error starting chunk thread: " 
		+ str(error), Debug.WARN, self)


func _chunk_thread_process(userdata: Dictionary): ##############################
	discover_surrounding_chunks(ChunkTools.get_chunk(userdata.player_position), 
		userdata.render_distance)
	process_chunks(userdata.chunks)
	_chunk_thread.call_deferred("wait_to_finish")
	#Core.emit_signal("msg", "Chunk thread finished!", Debug.DEBUG, self)
	_chunk_thread_busy = false


func process_chunks(chunks: Array): #######################################
	if !chunks:
		return false
	for node in chunks:
		if node.components.size() != 0:
			if node.components.rendered == false:
				_process_chunk(node)


func _process_chunk(node: Entity): #############################################
	var chunk = Spatial.new()
	chunk.name = "Chunk"
	
	if !node.components.block_data:
		var pos = node.components.position
		chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
		node.components.rendered = true
		Core.Client.chunk_index.append(pos)
		return
	
	# Returns blocks_loaded, mesh, vertex_data
	var chunk_data = compile(node.components.block_data, 
		BlockData.blocks()) 
	
	var mesh_instance = MeshInstance.new()
	mesh_instance.name = "MeshInstance"
	chunk.add_child(mesh_instance)
	mesh_instance.mesh = chunk_data.mesh
	
	var body = StaticBody.new()
	body.name = "StaticBody"
	mesh_instance.add_child(body)
	
	var collision_shape = CollisionShape.new()
	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	collision_shape.name = "CollisionShape"
	collision_shape.shape = shape
	body.add_child(collision_shape)
	
	Core.Client.blocks_found += node.components.block_data.size()
	Core.Client.blocks_loaded += chunk_data.blocks_loaded
	
	var pos = node.components.position
	chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
	node.components.rendered = true
	Core.Client.chunk_index.append(pos)
	
	node.call_deferred("add_child", chunk)
	
	if node.components.object != null or node.components.method != null:
		var error = connect("rendered", node.components.object, node.components.method)
		if error:
			emit_signal("msg", "Error on binding to rendered signal on chunk: " + str(error), Debug.WARN, self)
		emit_signal("rendered")


#VoxelTerrain._precalculate_priority_positions()
#VoxelTerrain._precalculate_neighboring()
#VoxelTerrain._update_pending_blocks()


# Creates one surrounding chunk per call
func discover_surrounding_chunks(center_chunk: Vector3, distance: int): ########
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
				var distance_squared = dx * dx + dy * dy 
				+ dz * dz
				
				if distance_squared <= (distance * distance):
					surrounding_chunks.append(
						Vector3(x, y, z))
	
	var chunks_to_create = []
	
	for chunk in surrounding_chunks:
		if !Core.Client.chunk_index.has(chunk):
			chunks_to_create.append(chunk)
	
	var min_distance = Core.Client.render_distance + 500
	var closest_chunk = Vector3()
	
	var woah = center_chunk.distance_to(Vector3(0, 0, 0))
	
	for chunk in chunks_to_create:
		if center_chunk.distance_to(chunk) < min_distance:
			min_distance = center_chunk.distance_to(chunk)
			closest_chunk = chunk
	
	if closest_chunk != Vector3(0, 0, 0):
		return ChunkManager.create_chunk(closest_chunk)
	
#	# Remove chunks outside of bounds
#	var entities = Entity.get_entities_with("chunk")
#	for id in entities:
#		var pos = Entity.get_component(id, "chunk.position")
#		if !surrounding_chunks.has(pos):
#			Core.Client.chunk_index.erase(pos)
#			if Entity.get_component(id, "chunk.blocks_loaded"):
#				Core.Client.blocks_loaded -= Entity.get_component(id, "chunk.blocks_loaded")
#				Core.Client.blocks_found -= Entity.get_component(id, "chunk.block_data").size()
#			Core.emit_signal("msg", "Destroyed chunk" + str(pos), Debug.DEBUG, self)
#			Entity.destory(id)


# Returns blocks_loaded, mesh, vertex_data
func compile(block_data: Dictionary, materials: Dictionary): ########################
	var blocks_loaded = 0
	Core.emit_signal("msg", "Compiling chunk...", Debug.TRACE, self)
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = null
	var mesh
	var vertex_data = []
	var block_data_ext = block_data
	
	#mat.albedo_color = Color(1, 0, 0, 1)
	
	for position in block_data.keys():
		if Geometry.can_be_seen(position, block_data).size() != 6:
			var cube_data = Geometry.create_cube(position, 
				block_data[position].id, mesh, materials, 
				block_data) # Returns mesh, vertex_data
			
			mesh = cube_data.mesh
			vertex_data += cube_data.vertex_data
			blocks_loaded += 1
	
	Core.emit_signal("msg", "Finished compiling!", Debug.DEBUG, self)
	return {"blocks_loaded" : blocks_loaded, "mesh" : mesh, "vertex_data" : 
		vertex_data}
