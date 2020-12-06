#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.manager",
	description = """
		
	"""
}

const DEFAULT_CHUNK = {
	meta = {
		system = "chunk",
		type = "chunk",
		id = str(Vector3(0, 0, 0)),
		seen = false,
		in_range = false,
		blocked = false
	},
	position = {
		world = Vector3(0, 0, 0),
		address = 0
	},
	mesh = {
		rendered = false,
		disabled = false,
		detailed = false,
		vertices = Array(),
		blocks = Dictionary(),
		blocks_loaded = 0
	},
	generator = {
		seed = 0
	}
}

const DEFAULT_VOXEL = {
	material = "example"
}

const EXAMPLE_MATERIAL = {
	name = "example",
	color = Color(0, 0, 0),  # the color & properties
	mass = 1,                # the weight of the voxel
	supports = 1*3           # the amount of mass the voxel can hold together
}

const DEFAULT_BLOCK = {
	#Vector3(0, 0, 0) = DEFAULT_VOXEL
}

static func create_chunk(position: Vector3): #################
	Core.emit_signal("msg", "Creating chunk " + str(position) + "...", 
		Core.DEBUG, meta)
	
	var chunk_data = Core.scripts.chunk.eden.world_decoder.get_chunk_data(position)
	
	if !chunk_data:
		chunk_data = generate_terrain(position)
	
	var chunk = DEFAULT_CHUNK.duplicate(true)
	chunk.meta.id = str(position)
	chunk.position.world = position
	chunk.mesh.blocks = chunk_data
	
	Core.client.data.subsystem.chunk.Link.create(chunk)
	
	if !chunk_data:
		return false
	
	return true


static func generate_chunk_components(node: Entity): ###########################
	var chunk = Spatial.new()
	chunk.name = "Chunk"
	
	if !node.components.mesh.blocks:
		var pos = node.components.position.world
		chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
		node.components.mesh.rendered = true
		Core.client.data.chunk_index.append(pos)
		return
	
	var line = ImmediateGeometry.new()
	line.name = "Highlight"
	node.add_child(line)
	draw_chunk_highlight(node, Color(255, 255, 255))
	
	var bline = ImmediateGeometry.new()
	bline.name = "BlockHighlight"
	node.add_child(bline)
	
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
	
	Core.client.data.blocks_found += node.components.mesh.blocks.size()
	
	var pos = node.components.position.world
	chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
	Core.client.data.chunk_index.append(pos)
	
	node.call_deferred("add_child", chunk)

static func draw_chunk_highlight(node: Entity, color: Color):
	var m = SpatialMaterial.new()
	#m.flags_use_point_size = true
	#m.params_point_size = 1
	m.vertex_color_use_as_albedo = true
	m.flags_unshaded = true
	m.albedo_color = color
	
	if !node.has_node("Highlight"):
		return
	
	var line = node.get_node("Highlight")
	if !line:
		return
	line.clear()
	line.set_material_override(m)
	line.begin(Mesh.PRIMITIVE_LINES)
	for point in Core.scripts.chunk.geometry.BOX_HIGHLIGHT_NO_OVERLAP:
		line.add_vertex(point*Core.scripts.chunk.geometry.CSIZE + (node.components.position.world*16) + Vector3(0, -1, 0))
	line.end()

static func draw_block_highlight(node: Entity, position: Vector3, color: Color):
	var m = SpatialMaterial.new()
	#m.flags_use_point_size = true
	#m.params_point_size = 1
	m.vertex_color_use_as_albedo = true
	m.flags_unshaded = true
	m.albedo_color = color
	
	var line = node.get_node("BlockHighlight")
	line.set_material_override(m)
	line.begin(Mesh.PRIMITIVE_LINES)
	for point in Core.scripts.chunk.geometry.BOX_HIGHLIGHT:
		line.add_vertex(point*Core.scripts.chunk.geometry.BSIZE + (node.components.position.world*16) + position + Vector3(0, -1, 0))
	line.end()

static func destroy_chunk(chunk: Entity): #########################################
	chunk.call_deferred("queue_free")
	Core.client.data.blocks_loaded -= chunk.components.mesh.blocks_loaded
	Core.client.data.blocks_found -= chunk.components.mesh.blocks.size()

static func generate_terrain(position: Vector3): ####################### #chunk_seed: int,
	var noise = Core.scripts.chunk.generator.generate_noise()
	
	if Core.server.data.map.generator.single_voxel:
		if position.x == 0 and position.y == 0 and position.z == 0:
			return Core.scripts.chunk.generator.single_voxel()
		else:
			return Dictionary()
	
	if Core.server.data.map.generator.terrain_type == Core.server.GEN_FLAT:
		return Core.scripts.chunk.generator.generate_flat_terrain()
	
	elif Core.server.data.map.generator.terrain_type == Core.server.GEN_NATURAL:
		return Core.scripts.chunk.generator.generate_natural_terrain(noise)
