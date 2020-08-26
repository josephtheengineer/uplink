# manages chunk data
# classified as a system because it gets run every frame and scans entities
extends Node
#warning-ignore:unused_class_variable
const script_name := "chunk_system"
onready var Debug := preload("res://src/scripts/debug/debug.gd").new()
onready var EdenWorldDecoder := preload("res://src/scripts/eden/world_decoder.gd").new()
onready var Manager := preload("res://src/scripts/manager/manager.gd").new()
onready var BlockData := preload("res://src/scripts/eden/block_data.gd").new()
onready var SystemManager := preload("res://src/scripts/manager/system.gd").new()
onready var TerrainGenerator := preload("res://src/scripts/world/terrain_generator.gd").new()
onready var Geometry := preload("res://src/scripts/world/geometry.gd").new()

onready var ChunkManager := preload("res://src/scripts/world/chunk_manager.gd").new()
onready var ChunkThread := preload("res://src/scripts/world/chunk_thread.gd").new()
onready var ModifyChunk := preload("res://src/scripts/world/modify_chunk.gd").new()
onready var ChunkTools := preload("res://src/scripts/world/chunk_tools.gd").new()


func _ready(): #################################################################
	Core.emit_signal("function_started", "_ready()", self)
	ChunkThread.start_chunk_thread()
	Core.emit_signal("system_ready", SystemManager.CHUNK, self)             ##### READY #####


func _process(_delta): #########################################################
	if !ChunkThread._chunk_thread_busy:
		ChunkThread.start_chunk_thread()


#func init_chunk(id: int): #####################################################
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


signal chunks_loaded
func load_player_spawn_chunks(object, method): #################################
	connect("chunks_loaded", object, method)
	var player = Core.get_parent().get_node(
		"World/Inputs/JosephTheEngineer/Player")
	
	var player_chunk = ChunkTools.get_chunk(player.translation)
	
	for x in range(-1, 2):
		for y in range(10):
			for z in range(-1, 2):
				ChunkManager.create_chunk(Vector3(player_chunk.x+x, 
					player_chunk.y-y, 
					player_chunk.z+z))
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.wait_time = 10
	Core.add_child(timer)
	timer.start()

func _on_timer_timeout():
	emit_signal("chunks_loaded")

func break_block(chunk: Entity, location: Vector3): ############################
	Core.emit_signal("msg", "Chunk position: " 
		+ str(chunk.components.position), Debug.DEBUG, self)
	Core.emit_signal("msg", "Removing block from chunk location " 
		+ str(location - chunk.components.position), Debug.INFO, self)
	
	chunk.components.block_data.erase(location - chunk.components.position)

	var chunk_data = ChunkThread.compile(chunk.components.block_data, 
		BlockData.blocks()) # Returns blocks_loaded, mesh, vertex_data

	chunk.get_node("Chunk/MeshInstance").mesh = chunk_data.mesh

	var shape = ConcavePolygonShape.new()
	shape.set_faces(chunk_data.vertex_data)
	chunk.get_node(
		"Chunk/MeshInstance/StaticBody/CollisionShape").shape = shape

func place_block(chunk: Entity, block_id: int, location: Vector3): #############
	if block_id == 0:
		return
	
	if !Core.get_parent().get_node("World/Chunks").has_node(chunk.name) or !chunk.has_node("Chunk"):
		Core.emit_signal("msg", "Invalid chunk!", Debug.WARN, self)
	
	#Hud.msg("Chunk translation: " + str(translation), Debug.DEBUG, self)
	#Hud.msg("Removing block from chunk location " + str(location - translation), Debug.INFO, self)
	
	chunk.components.block_data[location - chunk.components.position] = {
		id = block_id,
		color = 0,
	}
	
	ChunkThread._process_chunk(chunk)
