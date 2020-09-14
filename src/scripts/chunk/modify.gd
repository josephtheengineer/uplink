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
	chunk.components.rendered = false
	
	if Core.Client.data.subsystem.chunk.Link.data.destroyer_of_chunks:
		chunk.get_node("Chunk/MeshInstance").mesh = null

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
	chunk.components.rendered = false
