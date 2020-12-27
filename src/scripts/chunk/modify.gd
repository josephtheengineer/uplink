#warning-ignore:unused_class_variable
const meta := {
	script_name = "",
	description = """
		
	"""
}

# chunk.modify.break_block #####################################################
const break_block_meta := {
	func_name = "chunk.modify.break_block",
	description = """
		
	""",
		}
static func break_block(chunk: Entity, location: Vector3, args := break_block_meta) -> void:
	if !chunk.components.mesh.blocks:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position.world), Core.DEBUG, args)
	Core.emit_signal("msg", "Removing block from chunk location " 
		+ str(location), Core.INFO, args)
	
	chunk.components.mesh.blocks.erase(location)
	chunk.components.mesh.rendered = false
	
	if Core.Client.data.subsystem.chunk.Link.data.destroyer_of_chunks:
		var mesh_instance: MeshInstance = chunk.get_node("Chunk/MeshInstance")
		mesh_instance.mesh = null
# ^ chunk.modify.break_block ###################################################


# chunk.modify.place_block #####################################################
const place_block_meta := {
	func_name = "chunk.modify.place_block",
	description = """
		
	""",
		}
static func place_block(chunk: Entity, location: Vector3, block_id: int, args := place_block_meta) -> void:
	if !chunk.components.mesh.blocks:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position.world), Core.DEBUG, args)
	Core.emit_signal("msg", "Placing block at chunk location " 
		+ str(location), Core.INFO, args)
	
	chunk.components.mesh.blocks[location] = {
		id = block_id,
		color = 0,
	}
	chunk.components.mesh.rendered = false
# ^ chunk.modify.place_block ###################################################


# chunk.modify.break_voxel #####################################################
const break_voxel_meta := {
	func_name = "chunk.modify.break_voxel",
	description = """
		
	""",
		}
static func break_voxel(chunk: Entity, block_location: Vector3, location: Vector3, args := break_voxel_meta) -> void:
	if !chunk.components.mesh.blocks:
		return
	
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position.world), Core.DEBUG, args)
	Core.emit_signal("msg", "Modifing block from chunk location " 
		+ str(block_location), Core.INFO, args)
	Core.emit_signal("msg", "Removing voxel from block location " 
		+ str(location), Core.INFO, args)
	
	if  chunk.components.mesh.blocks.has(block_location):
		if chunk.components.mesh.blocks[block_location].voxels.has(location):
			chunk.components.mesh.blocks[block_location].voxels.erase(location)
			chunk.components.mesh.rendered = false
# ^ chunk.modify.break_voxel ###################################################
