# manages chunk data
# classified as a system because it gets run every frame and scans entities
extends Node
onready var Debug = preload("res://scripts/features/debug.gd").new()
onready var EdenWorldDecoder = preload("res://scripts/features/eden_world_decoder.gd").new()
onready var Entity = preload("res://scripts/features/entity.gd").new()
onready var BlockData = preload("res://scripts/features/block_data.gd").new()
onready var ServerSystem = get_node("/root/World/Systems/Server")
onready var ClientSystem = get_node("/root/World/Systems/Client")

var timer = 0
var chunks_processed_this_frame = 0
var chunk_wait_time = 0

var sur_chunk_x = 0
var sur_chunk_z = 0

func _ready():
	Debug.msg("Chunk System ready.", "Info")

func create_chunk(position):
	if chunks_processed_this_frame > 1:# and !Player.can_see_chunk(position):
		return false
	chunks_processed_this_frame+=1
	
	Debug.msg("Creating chunk " + str(position) + "...", "Debug")
	
	var chunk_data = EdenWorldDecoder.get_chunk_data(position)
	
	if !chunk_data:
		if ServerSystem.map_seed == 0:
			#chunk_data = TerrainGenerator.generate_natural_terrain()
			pass
		else:
			pass
			#chunk_data = TerrainGenerator.generate_flat_terrain()
	
	var chunk = Dictionary()
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
	
	Entity.create({"chunk" : chunk})
	
	return true

func destroy_chunk(position):
	#var chunk = Dictionary()
	var list = Entity.get_entities_with("chunk")
	for entity in list.values():
		if entity.components.chunk.position == position:
			Entity.destory(entity.id)

signal rendered
var thread

#func _process(delta):
#	chunks_processed_this_frame = 0
#	var entities = Entity.get_entities_with("chunk")
#	for id in entities:
#		var components = entities[id].components
#		if components.chunk.rendered == false and chunk_wait_time > 60:
#			chunk_wait_time=0
#			
#			_process_chunk(id)
#		else:
#			chunk_wait_time+=1
	
#	entities = Entity.get_entities_with("player")
#	for id in entities:
#		var player = "/root/World/" + str(id) + "/Player"
#		if has_node(player):
#			create_surrounding_chunks(get_chunk(get_node(player).translation), ClientSystem.render_distance)

func _process_chunk(id):
	var entities = Entity.get_entities_with("chunk")
	var components = entities[id].components
	var node = get_node("/root/World/" + str(id))
	
	var chunk = Spatial.new()
	chunk.name = "Chunk"
	node.add_child(chunk)
	
	if !components.chunk.block_data:
		var pos = components.chunk.position
		chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
		components.chunk.rendered = true
		ClientSystem.chunk_index.append(pos)
		Entity.edit(id, components)
		return
	
	var chunk_data = compile(components.chunk.block_data, BlockData.blocks(), components.chunk.position) # Returns blocks_loaded, mesh, vertex_data
	
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
	
	ClientSystem.blocks_found += components.chunk.block_data.size()
	ClientSystem.blocks_loaded += chunk_data.blocks_loaded
	
	var pos = components.chunk.position
	chunk.translation = Vector3(pos.x * 16, pos.y * 16, pos.z * 16)
	components.chunk.rendered = true
	ClientSystem.chunk_index.append(pos)
	Entity.edit(id, components)
	
	if components.chunk.object != null or components.chunk.method != null:
		connect("rendered", components.chunk.object, components.chunk.method)
		emit_signal("rendered")
	#_exit_tree()

# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
    thread.wait_to_finish()

#VoxelTerrain._precalculate_priority_positions()
#VoxelTerrain._precalculate_neighboring()
#VoxelTerrain._update_pending_blocks()

# Creates one surrounding chunk per call
func create_surrounding_chunks(center_chunk, distance):
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
	var cloest_chunk = Vector3()
	
	var woah = center_chunk.distance_to(Vector3(0, 0, 0))
	
	for chunk in chunks_to_create:
		if center_chunk.distance_to(chunk) < min_distance:
			min_distance = center_chunk.distance_to(chunk)
			cloest_chunk = chunk
	
	if cloest_chunk != Vector3(0, 0, 0):
		create_chunk(cloest_chunk)
	
	# Remove chunks outside of bounds
	var entities = Entity.get_entities_with("chunk")
	for id in entities:
		var pos = Entity.get_component(id, "chunk.position")
		if !surrounding_chunks.has(pos):
			ClientSystem.chunk_index.erase(pos)
			if Entity.get_component(id, "chunk.blocks_loaded"):
				ClientSystem.blocks_loaded -= Entity.get_component(id, "chunk.blocks_loaded")
				ClientSystem.blocks_found -= Entity.get_component(id, "chunk.block_data").size()
			Debug.msg("Destroyed chunk" + str(pos), "Debug")
			Entity.destory(id)

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
	Debug.msg("Compiling chunk...", "Info")
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
			#Debug.msg("Compiling block in position " + str(position), "Trace")
			var cube_data = Geometry.create_cube(position, block_data[position].id, mesh, materials, block_data) # Returns mesh, vertex_data
			mesh = cube_data.mesh
			vertex_data += cube_data.vertex_data
			blocks_loaded += 1
	
	#st.generate_normals(false)
	#st.index()
	#mesh = st.commit()
	Debug.msg("Finished compiling!", "Debug")
	return {"blocks_loaded" : blocks_loaded, "mesh" : mesh, "vertex_data" : vertex_data}


func break_block(chunk_id, location): ####################################################
	#Hud.msg("Chunk translation: " + str(translation), "Debug")
	#Hud.msg("Removing block from chunk location " + str(location - translation), "Info")
	
	var block_data = Entity.get_component(chunk_id, "chunk.block_data")
	block_data.erase(location - Entity.get_component(chunk_id, "chunk.position"))
	Entity.set_component(chunk_id, "chunk.block_data", block_data)

	var chunk_data = compile(Entity.get_component(chunk_id, "chunk.block_data"), Entity.get_component(chunk_id, "chunk.materials"), Entity.get_component(chunk_id, "chunk.position")) # Returns blocks_loaded, mesh, vertex_data
	
	get_node("/root/World/" + str(chunk_id) + "/Chunk/MeshInstance").mesh = chunk_data.mesh
	
	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	get_node("/root/World/" + str(chunk_id) + "/Chunk/MeshInstance/StaticBody/CollisionShape").shape = shape

func place_block(chunk_id, block_id, location): ####################################################
	if block_id == 0:
		return
	
	#Hud.msg("Chunk translation: " + str(translation), "Debug")
	#Hud.msg("Removing block from chunk location " + str(location - translation), "Info")
	
	var block_data = Entity.get_component(chunk_id, "chunk.block_data")
	block_data[location - Entity.get_component(chunk_id, "chunk.position")] = block_id
	Entity.set_component(chunk_id, "chunk.block_data", block_data)

	var chunk_data = compile(Entity.get_component(chunk_id, "chunk.block_data"), Entity.get_component(chunk_id, "chunk.materials"), Entity.get_component(chunk_id, "chunk.position")) # Returns blocks_loaded, mesh, vertex_data
	
	get_node("/root/World/" + str(chunk_id) + "/Chunk/MeshInstance").mesh = chunk_data.mesh
	
	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	get_node("/root/World/" + str(chunk_id) + "/Chunk/MeshInstance/StaticBody/CollisionShape").shape = shape

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
	var entities = Entity.get_entities_with("chunk")
	for id in entities:
		if Entity.get_component(id, "chunk.position") == location:
			return id
	return false