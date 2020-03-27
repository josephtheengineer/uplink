# manages chunk data
# classified as a system because it gets run every frame and scans entities
extends Node
var script_name = "chunk_system"
onready var Debug = preload("res://scripts/features/debug.gd").new()
onready var ServerSystem = get_node("/root/World/Systems/Server")
onready var ClientSystem = get_node("/root/World/Systems/Client")
onready var EdenWorldDecoder = preload("res://scripts/features/eden_world_decoder.gd").new()
onready var Manager = preload("res://scripts/features/manager.gd").new()
onready var BlockData = preload("res://scripts/features/block_data.gd").new()
onready var SystemManager = preload("res://scripts/features/system_manager.gd").new()
onready var TerrainGenerator = preload("res://scripts/features/terrain_generator.gd").new()
onready var Geometry = preload("res://scripts/features/geometry.gd").new()

var _chunk_thread := Thread.new()
var _chunk_thread_busy := false

func _ready():
	start_chunk_thread()
	Core.emit_signal("system_ready", SystemManager.CHUNK, self)                ##### READY #####

func _process(delta):
	if !_chunk_thread_busy:
		start_chunk_thread()

func create_chunk(position):
#	if chunks_processed_this_frame > 1:# and !Player.can_see_chunk(position):
#		return false
#	chunks_processed_this_frame+=1
	
	Core.emit_signal("msg", "Creating chunk " + str(position) + "...", Debug.DEBUG, self)
	
	var chunk_data = EdenWorldDecoder.get_chunk_data(position)
	
	if !chunk_data:
		if ServerSystem.map_seed == 0:
			if position.y == 0:
				chunk_data = TerrainGenerator.generate_natural_terrain()
		else:
			if position.y == 0:
				chunk_data = TerrainGenerator.generate_flat_terrain()
	
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
	
	return true

func destroy_chunk(position):
	pass
	#var chunk = Dictionary()
	#var list = Entity.get_entities_with("chunk")
	#for entity in list.values():
	#	if entity.components.position == position:
	#		Entity.destory(entity.id)

func start_chunk_thread():
	var userdata = {}
	if Core.get_parent().has_node("World/Inputs/JosephTheEngineer"):
		userdata.player_position = Core.get_parent().get_node("World/Inputs/JosephTheEngineer/Player").translation
		userdata.render_distance = ClientSystem.render_distance
		userdata.chunks = Manager.get_entities_with("Chunks")
		Core.emit_signal("msg", "Starting chunk thread...", Debug.DEBUG, self)
		_chunk_thread_busy = true
		_chunk_thread.start(self, "_chunk_thread_process", userdata)

func _chunk_thread_process(userdata):
	discover_surrounding_chunks(get_chunk(userdata.player_position), userdata.render_distance)
	process_chunks(userdata.chunks)
	_chunk_thread.call_deferred("wait_to_finish")
	Core.emit_signal("msg", "Chunk thread finished!", Debug.DEBUG, self)
	_chunk_thread_busy = false

func process_chunks(chunks):
	if chunks:
		for node in chunks:
			if node.components.size() != 0:
				if node.components.rendered == false:
					_process_chunk(node)

func _process_chunk(node):
	var chunk = Spatial.new()
	chunk.name = "Chunk"
	
	if !node.components.block_data:
		var pos = node.components.position
		chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
		node.components.rendered = true
		ClientSystem.chunk_index.append(pos)
		return
	
	var chunk_data = compile(node.components.block_data, BlockData.blocks(), node.components.position) # Returns blocks_loaded, mesh, vertex_data
	
	var mesh_instance = MeshInstance.new()
	mesh_instance.name = "MeshInstance"
	chunk.add_child(mesh_instance)
	mesh_instance.mesh = chunk_data.mesh
	
	var body = StaticBody.new()
	body.name = "StaticBody"
	mesh_instance.add_child(body)
	
	var collision_shape = CollisionShape.new()
	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	collision_shape.name = "CollisionShape"
	collision_shape.shape = shape
	body.add_child(collision_shape)
	
	ClientSystem.blocks_found += node.components.block_data.size()
	ClientSystem.blocks_loaded += chunk_data.blocks_loaded
	
	var pos = node.components.position
	chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
	node.components.rendered = true
	ClientSystem.chunk_index.append(pos)
	
	node.call_deferred("add_child", chunk)
	
	if node.components.object != null or node.components.method != null:
		connect("rendered", node.components.object, node.components.method)
		emit_signal("rendered")

#VoxelTerrain._precalculate_priority_positions()
#VoxelTerrain._precalculate_neighboring()
#VoxelTerrain._update_pending_blocks()

# Creates one surrounding chunk per call
func discover_surrounding_chunks(center_chunk, distance):
	var surrounding_chunks = []
	
	var top = center_chunk.x - distance;
	var bottom = top + distance * 2;
	
	var front = center_chunk.y - distance;
	var back = front + distance * 2;
	
	var left = center_chunk.z - distance;
	var right = left + distance * 2;
	
	for x in range(top, bottom):
		for y in range(front, back):
			for z in range(left, right):
				var dx = x - center_chunk.x
				var dy = y - center_chunk.y
				var dz = z - center_chunk.z
				var distance_squared = dx * dx + dy * dy + dz * dz
				
				if distance_squared <= (distance * distance):
					surrounding_chunks.append(Vector3(x, y, z))
	
	var chunks_to_create = []
	
	
	
	for chunk in surrounding_chunks:
		if !ClientSystem.chunk_index.has(chunk):
			chunks_to_create.append(chunk)
	
	var min_distance = ClientSystem.render_distance + 500
	var closest_chunk = Vector3()
	
	var woah = center_chunk.distance_to(Vector3(0, 0, 0))
	
	for chunk in chunks_to_create:
		if center_chunk.distance_to(chunk) < min_distance:
			min_distance = center_chunk.distance_to(chunk)
			closest_chunk = chunk
	
	if closest_chunk != Vector3(0, 0, 0):
		create_chunk(closest_chunk)
	
#	# Remove chunks outside of bounds
#	var entities = Entity.get_entities_with("chunk")
#	for id in entities:
#		var pos = Entity.get_component(id, "chunk.position")
#		if !surrounding_chunks.has(pos):
#			ClientSystem.chunk_index.erase(pos)
#			if Entity.get_component(id, "chunk.blocks_loaded"):
#				ClientSystem.blocks_loaded -= Entity.get_component(id, "chunk.blocks_loaded")
#				ClientSystem.blocks_found -= Entity.get_component(id, "chunk.block_data").size()
#			Core.emit_signal("msg", "Destroyed chunk" + str(pos), Debug.DEBUG, self)
#			Entity.destory(id)

#func init_chunk(id):
#	if World.map_seed == -1 and chunk_location == Vector3(0, 0, 0):
#		var chunk_data = TerrainGenerator.generate_random_terrain()
#		for position in chunk_data.keys():
#			place_block(chunk_data[position], position)
#		
#		compile()
#	elif World.map_seed == 0:
#		var chunk_data = TerrainGenerator.generate_flat_terrain()
#		for position in chunk_data.keys():
#			place_block(chunk_data[position], position)
#		
#		compile()
#	else:
#		var chunk_data = TerrainGenerator.generate_natural_terrain()
#		for position in chunk_data.keys():
#			place_block(chunk_data[position], position)
#		
#		compile()

func compile(block_data, materials, pos): # Returns blocks_loaded, mesh, vertex_data
	var blocks_loaded = 0
	Core.emit_signal("msg", "Compiling chunk...", Debug.INFO, self)
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = null
	var mesh
	var vertex_data = []
	var block_data_ext = block_data
	
	#mat.albedo_color = Color(1, 0, 0, 1)
	
	#for surrounding_position in Geometry.surrounding_blocks:
	#	var block_data_temp = EdenWorldDecoder.get_chunk_data(pos + surrounding_position)
	#	for block in block_data_temp.keys():
	#		block_data_ext[block + surrounding_position * 16] = block_data_temp[block]
	
	for position in block_data.keys():
		if Geometry.can_be_seen(position, block_data).size() != 6:# and position.y > 20:
			#Core.emit_signal("msg", "Compiling block in position " + str(position), Debug.TRACE, self)
			var cube_data = Geometry.create_cube(position, block_data[position].id, mesh, materials, block_data) # Returns mesh, vertex_data
			mesh = cube_data.mesh
			vertex_data += cube_data.vertex_data
			blocks_loaded += 1
	
	#st.generate_normals(false)
	#st.index()
	#mesh = st.commit()
	Core.emit_signal("msg", "Finished compiling!", Debug.DEBUG, self)
	return {"blocks_loaded" : blocks_loaded, "mesh" : mesh, "vertex_data" : vertex_data}

signal chunks_loaded
func load_player_spawn_chunks(object, method):
	connect("chunks_loaded", object, method)
	var player_chunk = get_chunk(Core.get_parent().get_node("World/Inputs/JosephTheEngineer/Player").translation)
	for i in range(10):
		create_chunk(Vector3(player_chunk.x, player_chunk.y-i, player_chunk.z))
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.wait_time = 5
	Core.add_child(timer)
	timer.start()

func _on_timer_timeout():
	emit_signal("chunks_loaded")

func break_block(chunk, location): ####################################################
	Core.emit_signal("msg", "Chunk position: " + str(chunk.components.position), Debug.DEBUG, self)
	Core.emit_signal("msg", "Removing block from chunk location " + str(location - chunk.components.position), Debug.INFO, self)
	
	chunk.components.block_data.erase(location - chunk.components.position)

	var chunk_data = compile(chunk.components.block_data, chunk.components.materials, chunk.components.position) # Returns blocks_loaded, mesh, vertex_data

	chunk.get_node("Chunk/MeshInstance").mesh = chunk_data.mesh

	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	chunk.get_node("Chunk/MeshInstance/StaticBody/CollisionShape").shape = shape

func place_block(chunk_id, block_id, location): ####################################################
	if block_id == 0:
		return
	
	#Hud.msg("Chunk translation: " + str(translation), Debug.DEBUG, self)
	#Hud.msg("Removing block from chunk location " + str(location - translation), Debug.INFO, self)
	
#	var block_data = Entity.get_component(chunk_id, "chunk.block_data")
#	block_data[location - Entity.get_component(chunk_id, "chunk.position")] = block_id
#	Entity.set_component(chunk_id, "chunk.block_data", block_data)
#
#	var chunk_data = compile(Entity.get_component(chunk_id, "chunk.block_data"), Entity.get_component(chunk_id, "chunk.materials"), Entity.get_component(chunk_id, "chunk.position")) # Returns blocks_loaded, mesh, vertex_data
#
#	get_node("/root/World/" + str(chunk_id) + "/Chunk/MeshInstance").mesh = chunk_data.mesh
#
#	var shape = ConcavePolygonShape.new()
#	shape.set_faces(chunk_data.vertex_data)
#	get_node("/root/World/" + str(chunk_id) + "/Chunk/MeshInstance/StaticBody/CollisionShape").shape = shape

func get_chunk_sub(location): #################################################
	var x = 0
	if location == 0:
		return 0
	elif location > 0:
		while !(location >= x and location < x*16):
			x += 1
	else:
		while !(location <= x and location > x*16):
			x -= 1
	return x - 1


func get_chunk(location): #####################################################
	var x = get_chunk_sub(int(round(location.x)))
	var y = get_chunk_sub(int(round(location.y)))
	var z = get_chunk_sub(int(round(location.z)))
	
	return Vector3(x, y, z)

func get_chunk_id(location):
	pass
#	var entities = Entity.get_entities_with("chunk")
#	for id in entities:
#		if Entity.get_component(id, "chunk.position") == location:
#			return id
#	return false
