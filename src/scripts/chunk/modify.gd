#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.modify",
	description = """
		
	"""
}

static func break_block(chunk: Entity, location: Vector3): #####################
	if !chunk.components.mesh.blocks:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position.world), Core.DEBUG, meta)
	Core.emit_signal("msg", "Removing block from chunk location " 
		+ str(location), Core.INFO, meta)
	
	chunk.components.mesh.blocks.erase(location)
	chunk.components.mesh.rendered = false
	
	if Core.Client.data.subsystem.chunk.Link.data.destroyer_of_chunks:
		chunk.get_node("Chunk/MeshInstance").mesh = null

static func place_block(chunk: Entity, location: Vector3, block_id: int): ######
	if !chunk.components.mesh.blocks:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position.world), Core.DEBUG, meta)
	Core.emit_signal("msg", "Placing block at chunk location " 
		+ str(location), Core.INFO, meta)
	
	chunk.components.mesh.blocks[location] = {
		id = block_id,
		color = 0,
	}
	chunk.components.mesh.rendered = false


static func break_voxel(chunk: Entity, block_location: Vector3, location: Vector3): 
	if !chunk.components.mesh.blocks:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position.world), Core.DEBUG, meta)
	Core.emit_signal("msg", "Modifing block from chunk location " 
		+ str(block_location), Core.INFO, meta)
	Core.emit_signal("msg", "Removing voxel from block location " 
		+ str(location), Core.INFO, meta)
	
	if chunk.components.mesh.blocks[block_location].voxels.has(location):
		chunk.components.mesh.blocks[block_location].voxels.erase(location)
		chunk.components.mesh.rendered = false
