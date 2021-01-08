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


# chunk.manager.create_chunk ###################################################
const create_chunk_meta := {
	func_name = "chunk.manager.create_chunk",
	description = """
		
	""",
		}
static func create_chunk(position: Vector3, args := create_chunk_meta) -> bool: 
	Core.emit_signal("msg", "Creating chunk " + str(position) + "...", 
		Core.TRACE, args)
	
	var chunk_data = Core.run("chunk.eden.world_decoder.get_chunk_data", {location = position}).data
	
	if !chunk_data:
		chunk_data = generate_terrain(position)
	
	var chunk = DEFAULT_CHUNK.duplicate(true)
	chunk.meta.id = str(position)
	chunk.position.world = position
	chunk.mesh.blocks = chunk_data
	
	var create_m = Core.world.get_node("Chunk").create_meta
	create_m.entity = chunk
	Core.world.get_node("Chunk").create(create_m)
	
	if !chunk_data:
		#Core.emit_signal("msg", "Could not generate or find chunk data for " + str(position), Core.DEBUG, args)
		return false
	
	return true
# ^ chunk.manager.create_chunk #################################################


# chunk.helper.generate_chunk_components ########################################
const generate_chunk_components_meta := {
	func_name = "chunk.manager.generate_chunk_components",
	description = """
		
	""",
		}
static func generate_chunk_components(node: Entity, args := generate_chunk_components_meta) -> void: 
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
	var origin = ImmediateGeometry.new()
	origin.name = "Origin"
	node.add_child(origin)
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
	chunk.translation = Vector3(pos.x * 16-8, pos.y * 16-8, pos.z * 16-8)
	Core.client.data.chunk_index.append(pos)
	
	node.call_deferred("add_child", chunk)
# ^ chunk.helper.generate_chunk_components #####################################


# chunk.helper.draw_chunk_highlight ############################################
const draw_chunk_highlight_meta := {
	func_name = "chunk.manager.draw_chunk_highlight",
	description = """
		
	""",
		}
static func draw_chunk_highlight(node: Entity, color: Color, args := draw_chunk_highlight_meta) -> void: 
	var m = SpatialMaterial.new()
	#m.flags_use_point_size = true
	#m.params_point_size = 1
	m.vertex_color_use_as_albedo = true
	m.flags_unshaded = true
	m.albedo_color = color
	
	if !node or !node.has_node("Highlight") or !node.has_node("Chunk"):
		return
	
	var line = node.get_node("Highlight")
	if !line:
		return
	line.clear()
	line.set_material_override(m)
	line.begin(Mesh.PRIMITIVE_LINES)
	for point in Core.scripts.chunk.geometry.BOX_HIGHLIGHT_NO_OVERLAP:
		line.add_vertex(point*Core.scripts.chunk.geometry.CSIZE + (node.get_node("Chunk").translation))
	line.add_vertex(node.get_node("Chunk").translation)
	line.end()
	
	# Origin ###############################################################
	m = SpatialMaterial.new()
	#m.flags_use_point_size = true
	#m.params_point_size = 1
	m.vertex_color_use_as_albedo = true
	m.flags_unshaded = true
	m.albedo_color = color
	
	if !node or !node.has_node("Origin") or !node.has_node("Chunk"):
		return
	
	line = node.get_node("Origin")
	if !line:
		return
	line.clear()
	line.set_material_override(m)
	line.begin(Mesh.PRIMITIVE_LINES)
	for point in Core.scripts.chunk.geometry.BOX_ORIGIN:
		line.add_vertex(point*Core.scripts.chunk.geometry.CSIZE/2 + (node.get_node("Chunk").translation) + Vector3(8, 8, 8))
	line.add_vertex(node.get_node("Chunk").translation)
	line.end()
# chunk.helper.draw_chunk_highlight ############################################


# chunk.helper.draw_block_highlight ############################################
const draw_block_highlight_meta := {
	func_name = "chunk.manager.draw_block_highlight",
	description = """
		
	""",
		}
static func draw_block_highlight(node: Entity, position: Vector3, color: Color, args := draw_block_highlight_meta) -> void: 
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
		line.add_vertex(point*Core.scripts.chunk.geometry.BSIZE + (
			node.get_node("Chunk").translation
			) + position + Vector3(
				7.5 - Core.scripts.chunk.geometry.VSIZE/2,
				7.5 - Core.scripts.chunk.geometry.VSIZE/2,
				7.5 - Core.scripts.chunk.geometry.VSIZE/2
			)
		)
	line.end()
# ^ chunk.helper.draw_block_highlight ##########################################


# chunk.helper.destroy_chunk ###################################################
const destroy_chunk_meta := {
	func_name = "chunk.manager.destroy_chunk",
	description = """
		
	""",
		}
static func destroy_chunk(chunk: Entity, args := destroy_chunk_meta) -> void: ##
	chunk.call_deferred("queue_free")
	Core.client.data.blocks_loaded -= chunk.components.mesh.blocks_loaded
	Core.client.data.blocks_found -= chunk.components.mesh.blocks.size()
# ^ chunk.helper.destroy_chunk #################################################


# chunk.helper.generate_terrain ################################################
const generate_terrain_meta := {
	func_name = "chunk.manager.generate_terrain",
	description = """
		
	""",
		}
static func generate_terrain(position: Vector3, args := generate_terrain_meta) -> Dictionary:
	var new_noise = Core.run("chunk.generator.noise").noise
	
	if Core.server.data.map.generator.single_voxel:
		if position.x == 0 and position.y == 0 and position.z == 0:
			return Core.run("chunk.generator.single_voxel").data
		else:
			return Dictionary()
	
	if Core.server.data.map.generator.terrain_type == Core.server.GEN_FLAT:
		return Core.run("chunk.generator.flat_terrain").data
	#elif Core.server.data.map.generator.terrain_type == Core.server.GEN_NATURAL:
	return Core.run("chunk.generator.flat_terrain", {noise=new_noise}).data
# ^ chunk.helper.generate_terrain ##############################################


# chunk.helper.get_node ########################################################
const get_node_meta := {
	func_name = "chunk.manager.get_node",
	description = """
		
	""",
		position = null}
static func get_node(args := get_node_meta) -> void:
	Core.world.get_node("Chunk/" + str(args.position))
# ^ chunk.helper.get_node ##############################################
