#warning-ignore:unused_class_variable
const script_name := "chunk_manager"
var Debug := preload("res://src/scripts/debug/debug.gd").new()
var EdenWorldDecoder := preload("res://src/scripts/eden/world_decoder.gd").new()
var Manager := preload("res://scripts/manager/manager.gd").new()
var TerrainGenerator := preload("res://scripts/world/terrain_generator.gd").new()

func create_chunk(position: Vector3): ##########################################
	Core.emit_signal("msg", "Creating chunk " + str(position) + "...", 
		Debug.DEBUG, self)
	
	var chunk_data = EdenWorldDecoder.get_chunk_data(position)
	
	if !chunk_data:
		chunk_data = generate_terrain(Core.Server.map_seed, position)
	
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
	
	Manager.create(chunk)
	
	if !chunk_data:
		return false
	
	return true


func destroy_chunk(position: Vector3): #########################################
	Core.emit_signal("msg", "Destroying a chunk is not implemented yet!", 
		Debug.WARN, self)
	#var chunk = Dictionary()
	#var list = Entity.get_entities_with("chunk")
	#for entity in list.values():
	#	if entity.components.position == position:
	#		Entity.destory(entity.id)

func generate_terrain(map_seed: int, position: Vector3): #######################
	if map_seed == 0:
		if position.y == 0:
			return TerrainGenerator.generate_natural_terrain()
	else:
		if position.y == 0:
			return TerrainGenerator.generate_flat_terrain()
