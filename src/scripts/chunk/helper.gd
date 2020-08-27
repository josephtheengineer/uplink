#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.helper",
	description = """
		
	"""
}

#static func init_chunk(id: int): ##############################################
#	if World.map_seed == -1 and chunk_location == Vector3(0, 0, 0):
#		var chunk_data = TerrainGenerator.generate_random_terrain()
#		for position in chunk_data.keys():
#			place_block(chunk_data[position], position)
#		
#		compile()
#	elif World.map_seed == 0:
#		var chunk_data = TerrainGenerator.generate_flat_terrain()
#		for position in chunk_data.keys():
#			place_block(chunk_data[position], position)
#		
#		compile()
#	else:
#		var chunk_data = TerrainGenerator.generate_natural_terrain()
#		for position in chunk_data.keys():
#			place_block(chunk_data[position], position)
#		
#		compile()


signal chunks_loaded
static func load_player_spawn_chunks(object, method): ##########################
	var err: int = Core.connect("chunks_loaded", object, method)
	if err:
		Core.emit_signal("msg", "Error on binding to chunks_loaded"
			+ ": " + str(err), Core.WARN, meta)
	
	var player = Core.get_parent().get_node(
		"World/Inputs/JosephTheEngineer/Player")
	
	var tools = Core.scripts.chunk.tools
	var player_chunk = tools.get_chunk(player.translation)
	
	for x in range(-1, 2):
		for y in range(10):
			for z in range(-1, 2):
				Core.scripts.chunk.manager.create_chunk(
					Vector3(
						player_chunk.x+x, 
						player_chunk.y-y, 
						player_chunk.z+z
					)
				)
	
	#var timer = Timer.new()
	#timer.connect("timeout", self, "_on_timer_timeout")
	#timer.wait_time = 10
	#Core.add_child(timer)
	#timer.start()
	_on_timer_timeout()

static func _on_timer_timeout():
	Core.emit_signal("chunks_loaded")

static func break_block(chunk, location: Vector3): #############################
	chunk = Dictionary()
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position), Core.DEBUG, meta)
	Core.emit_signal("msg", "Removing block from chunk location " 
		+ str(location - chunk.components.position), Core.INFO, meta)
	
	chunk.components.block_data.erase(location - chunk.components.position)

	# Returns blocks_loaded, mesh, vertex_data
	var chunk_data = Core.scriptss.chunk.thread.compile(
		chunk.components.block_data, 
		Core.scriptss.eden.block_data.blocks()
	) 

	var mesh: MeshInstance = chunk.get_node("Chunk/MeshInstance")
	mesh.mesh = chunk_data.mesh

	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	var node: CollisionShape = chunk.get_node(
		"Chunk/MeshInstance/StaticBody/CollisionShape"
	)
	node.shape = shape

#static func place_block(chunk: int, block_id: int, location: Vector3): ########
	#if block_id == 0:
		#return
	
	#if !Core.get_parent().get_node("World/Chunks").has_node(chunk.name) or !chunk.has_node("Chunk"):
		#Core.emit_signal("msg", "Invalid chunk!", Core.WARN, self)
	
	#Hud.msg("Chunk translation: " + str(translation), Core.DEBUG, self)
	#Hud.msg("Removing block from chunk location " + str(location - translation), Core.INFO, self)
	
	#chunk.components.block_data[location - chunk.components.position] = {
	#	id = block_id,
	#	color = 0,
	#}
	
	#ChunkThread._process_chunk(chunk)
