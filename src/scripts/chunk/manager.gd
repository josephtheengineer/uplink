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
	
	#if !chunk_data:
		#return
	
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


static func generate_chunk_components(node: Entity): ###########################
	var chunk = Spatial.new()
	chunk.name = "Chunk"
	
	if !node.components.block_data:
		var pos = node.components.position
		chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
		node.components.rendered = true
		Core.Client.data.chunk_index.append(pos)
		return
	
	var line = ImmediateGeometry.new()
	line.name = "Highlight"
	node.add_child(line)
	draw_chunk_highlight(node, Color(255, 255, 255))
	
	var mesh_instance = MeshInstance.new()
	mesh_instance.name = "MeshInstance"
	chunk.add_child(mesh_instance)
	
	
	var body = StaticBody.new()
	body.name = "StaticBody"
	mesh_instance.add_child(body)
	
	#var units = 1
	#mesh_instance.scale = Vector3(0.063, 0.063, 0.063)
	
	var collision_shape = CollisionShape.new()
	collision_shape.name = "Shape"
	body.add_child(collision_shape)
	
	Core.Client.data.blocks_found += node.components.block_data.size()
	
	var pos = node.components.position
	chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
	Core.Client.data.chunk_index.append(pos)
	
	node.call_deferred("add_child", chunk)
	
	if node.components.object != null or node.components.method != null:
		var error = Core.connect("rendered", node.components.object, node.components.method)
		if error:
			Core.emit_signal("msg", "Error on binding to rendered signal on chunk: " + str(error), Core.WARN, meta)
		Core.emit_signal("rendered")
		

static func draw_chunk_highlight(node: Entity, color: Color):
	var m = SpatialMaterial.new()
	#m.flags_use_point_size = true
	#m.params_point_size = 1
	m.vertex_color_use_as_albedo = true
	m.flags_unshaded = true
	m.albedo_color = color
	
	var line = node.get_node("Highlight")
	line.clear()
	line.set_material_override(m)
	line.begin(Mesh.PRIMITIVE_LINES)
	for point in Core.scripts.chunk.geometry.BOX_HIGHLIGHT:
		line.add_vertex(point*Core.scripts.chunk.geometry.CSIZE + (node.components.position*16) + Vector3(0, -1, 0))
	line.end()

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
		if position.y == 1 and position.x == 1 and position.z == 1:
			return Core.scripts.chunk.generator.generate_flat_terrain()
	else:
		if position.y == 0:
			return Core.scripts.chunk.generator.generate_natural_terrain(noise)
