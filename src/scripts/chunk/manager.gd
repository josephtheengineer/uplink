#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.manager",
	description = """
		
	"""
}

static func create_chunk(position: Vector3): ##########################################
	Core.emit_signal("msg", "Creating chunk " + str(position) + "...", 
		Core.DEBUG, meta)
	
	var chunk_data = Core.scripts.eden.world_decoder.get_chunk_data(position)
	
	if !chunk_data:
		chunk_data = generate_terrain(Core.Server.data.map.seed, position)
	
	var chunk = Dictionary()
	chunk.name_id = "chunk"
	chunk.type = "chunk"
	chunk.id = position
	chunk.rendered = false
	chunk.position = position
	chunk.address = 0
	chunk.gen_seed = 0
	chunk.block_data = chunk_data
	chunk.blocks_loaded = 0
	chunk.mesh = null
	chunk.vertex_data = Array()
	chunk.shape = null
	chunk.materials = Dictionary()
	chunk.entities = Dictionary()
	chunk.object = null
	chunk.method = null
	
	Core.scripts.core.manager.create(chunk)
	
	if !chunk_data:
		return false
	
	return true


static func destroy_chunk(_position: Vector3): #########################################
	Core.emit_signal("msg", "Destroying a chunk is not implemented yet!", 
		Core.WARN, meta)
	#var chunk = Dictionary()
	#var list = Entity.get_entities_with("chunk")
	#for entity in list.values():
	#	if entity.components.position == position:
	#		Entity.destory(entity.id)

static func generate_terrain(map_seed: int, position: Vector3): #######################
	var noise = Core.scripts.chunk.generator.generate_noise()
	if map_seed == 0:
		if position.y == 0:
			return Core.scripts.chunk.generator.generate_natural_terrain(noise)
	else:
		if position.y == 0:
			return Core.scripts.chunk.generator.generate_flat_terrain(noise)
