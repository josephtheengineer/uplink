#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.test.single_block",
	type = "process",
	steps = [
		"setup_environment",
		"entity_exists",
		"valid_schema",
		"wait_for_compile",
		"mesh_rendered",
		"blocks_loaded_count",
		"block_data_size",
		"vertices_size",
		"spatial_node",
		"mesh_instance",
		"static_body",
		"shape"
	],
	description = """
		
	"""
}


# core.test.single_block.start #################################################
const start_meta := {
	func_name = "core.test.single_block.start",
	description = """
		Tests the engine for single block generation
	"""
		}
static func start(_args := start_meta) -> void: ################################
	Core.emit_signal("system_process_start", "core.test.single_block")
# ^ core.test.single_block.start ###############################################


static func setup_environment():
	Core.emit_signal("system_process", meta, "setup_environment", "start")
	
	Core.world.get_node("Interface/Hud/Hud/Background").visible = false
	Core.scripts.input.cli.reset()
	Core.world.get_node("Interface/Hud/Hud/Background").visible = false
	
	# Make the world generator generate 1 block only
	Core.server.data.map.generator.single_voxel = true
	
	Core.emit_signal("system_process_start", "server.bootup")
	Core.emit_signal("system_process_start", "client.connect")
	Core.emit_signal("system_process_start", "client.spawn")
	
	# Get the set player from the input system
	var player_name = Core.client.data.subsystem.input.Link.data.player
	var player = Core.world.get_node("Input/" + player_name)
	
	# Set the edit mode on the player to voxels
	player.components.action.resolution = 16 # RES_2
	
	# Tp the player to the correct position
	player.get_node("Player").translation = Vector3(0, 0, 0)
	Core.scripts.chunk.manager.create_chunk(Vector3(0, 0, 0))
	
	Core.emit_signal("system_process", meta, "setup_environment", "success")

static func entity_exists():
	Core.emit_signal("system_process", meta, "entity_exists", "start")
	
	if Core.world.has_node("Chunk/(0, 0, 0)"):
		Core.emit_signal("system_process", meta, "entity_exists", "success")
	else:
		Core.emit_signal("system_process", meta, "entity_exists", "chunk entity node does not exist")

static func valid_schema():
	Core.emit_signal("system_process", meta, "valid_schema", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.components.meta.system == "chunk" \
	and chunk.components.meta.type == "chunk" \
	and chunk.components.meta.id == str(Vector3(0, 0, 0)) \
	and chunk.components.position.world == Vector3(0, 0, 0):
		Core.emit_signal("system_process", meta, "valid_schema", "success")
	else:
		Core.emit_signal("system_process", meta, "valid_schema", "chunk data is invalid")

static func wait_for_compile():
	Core.emit_signal("system_process", meta, "wait_for_compile", "start")
	
	Core.emit_signal("msg", "Waiting for the chunk to compile...", Core.INFO, meta)
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 5
	Core.add_child(timer)
	timer.start()
	yield(timer,"timeout")
	
	Core.emit_signal("system_process", meta, "wait_for_compile", "success")

static func mesh_rendered():
	Core.emit_signal("system_process", meta, "mesh_rendered", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.components.mesh.rendered == true:
		Core.emit_signal("system_process", meta, "mesh_rendered", "success")
	else:
		Core.emit_signal("system_process", meta, "mesh_rendered", "chunk mesh is not rendered")

static func blocks_loaded_count():
	Core.emit_signal("system_process", meta, "blocks_loaded_count", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.components.mesh.blocks_loaded == 1:
		Core.emit_signal("system_process", meta, "blocks_loaded_count", "success")
	else:
		Core.emit_signal("system_process", meta, "blocks_loaded_count", "incorrect number of blocks loaded")

static func block_data_size():
	Core.emit_signal("system_process", meta, "block_data_size", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.components.mesh.blocks:
		if chunk.components.mesh.blocks.size() == 1:
			Core.emit_signal("system_process", meta, "block_data_size", "success")
		else:
			Core.emit_signal("system_process", meta, "block_data_size", "incorrect number of blocks saved")
	else:
		Core.emit_signal("system_process", meta, "block_data_size", "number of blocks saved was null")

static func vertices_size():
	Core.emit_signal("system_process", meta, "vertices_size", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	
	var mesh = chunk.get_node("Chunk/MeshInstance").mesh
	
	Core.emit_signal("msg", "Verts in block/chunk: " + str(mesh.surface_get_array_len(0)), Core.INFO, meta)
	
	if mesh.surface_get_array_len(0) == 36:
		Core.emit_signal("system_process", meta, "vertices_size", "success")
	else:
		Core.emit_signal("system_process", meta, "vertices_size", str(mesh.surface_get_array_len(0)) + " vertices saved when 36 was expected")

static func spatial_node():
	Core.emit_signal("system_process", meta, "spatial_node", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.has_node("Chunk"):
		Core.emit_signal("system_process", meta, "spatial_node", "success")
	else:
		Core.emit_signal("system_process", meta, "spatial_node", "spatial node does not exist")

static func mesh_instance():
	Core.emit_signal("system_process", meta, "mesh_instance", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.has_node("Chunk"):
		if chunk.get_node("Chunk").has_node("MeshInstance"):
			Core.emit_signal("system_process", meta, "mesh_instance", "success")
		else:
			Core.emit_signal("system_process", meta, "mesh_instance", "mesh instance node does not exist")
	else:
		Core.emit_signal("system_process", meta, "mesh_instance", "spatial node does not exist")

static func static_body():
	Core.emit_signal("system_process", meta, "static_body", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.has_node("Chunk"):
		if chunk.get_node("Chunk").has_node("MeshInstance"):
			if chunk.get_node("Chunk").get_node("MeshInstance").has_node("StaticBody"):
				Core.emit_signal("system_process", meta, "static_body", "success")
			else:
				Core.emit_signal("system_process", meta, "static_body", "static body node does not exist")
		else:
			Core.emit_signal("system_process", meta, "static_body", "mesh instance node does not exist")
	else:
		Core.emit_signal("system_process", meta, "static_body", "spatial node does not exist")

static func shape():
	Core.emit_signal("system_process", meta, "shape", "start")
	
	var chunk = Core.world.get_node("Chunk/(0, 0, 0)")
	if chunk.has_node("Chunk"):
		if chunk.get_node("Chunk").has_node("MeshInstance"):
			if chunk.get_node("Chunk/MeshInstance").has_node("StaticBody"):
				if chunk.get_node("Chunk").get_node("MeshInstance").get_node("StaticBody").has_node("Shape"):
					Core.emit_signal("system_process", meta, "shape", "success")
				else:
					Core.emit_signal("system_process", meta, "shape", "shape node does not exist")
			else:
				Core.emit_signal("system_process", meta, "shape", "static body node does not exist")
		else:
			Core.emit_signal("system_process", meta, "shape", "mesh instance node does not exist")
	else:
		Core.emit_signal("system_process", meta, "shape", "spatial node does not exist")
