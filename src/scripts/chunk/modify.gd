#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.modify",
	description = """
		
	"""
}

static func break_block(chunk: Entity, location: Vector3): #####################
	if !chunk.components.block_data:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position), Core.DEBUG, meta)
	Core.emit_signal("msg", "Removing block from chunk location " 
		+ str(location), Core.INFO, meta)
	
	chunk.components.block_data.erase(location)
	
	var mesh: MeshInstance = chunk.get_node("Chunk/MeshInstance")
	mesh.mesh = null
	
	# Returns blocks_loaded, mesh, vertex_data
	var chunk_data = Core.scripts.chunk.thread.compile(
		chunk.components.block_data, 
		Core.scripts.eden.block_data.blocks()
	) 
	
	if !Core.Client.data.subsystem.chunk.Link.data.destroyer_of_chunks:
		mesh.mesh = chunk_data.mesh
	
	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	var node: CollisionShape = chunk.get_node(
		"Chunk/MeshInstance/StaticBody/CollisionShape"
	)
	node.shape = shape

static func place_block(chunk: Entity, location: Vector3, block_id: int): #####################
	if !chunk.components.block_data:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position), Core.DEBUG, meta)
	Core.emit_signal("msg", "Placing block at chunk location " 
		+ str(location), Core.INFO, meta)
	
	chunk.components.block_data[location] = {
		id = block_id,
		color = 0,
	}
	
	var mesh: MeshInstance = chunk.get_node("Chunk/MeshInstance")
	mesh.mesh = null
	
	# Returns blocks_loaded, mesh, vertex_data
	var chunk_data = Core.scripts.chunk.thread.compile(
		chunk.components.block_data, 
		Core.scripts.eden.block_data.blocks()
	) 
	
	if !Core.Client.data.subsystem.chunk.Link.data.destroyer_of_chunks:
		mesh.mesh = chunk_data.mesh
	
	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	var node: CollisionShape = chunk.get_node(
		"Chunk/MeshInstance/StaticBody/CollisionShape"
	)
	node.shape = shape
