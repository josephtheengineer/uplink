extends Node
var Entity = load("res://scripts/features/entity.gd")
var Player = load("res://scripts/features/player.gd")
onready var ChunkSystem = get_node("/root/World/Systems/Chunk")
onready var ClientSystem = get_node("/root/World/Systems/Client")
onready var ServerSystem = get_node("/root/World/Systems/Server")

func player_move_update(id):
	var stats = "/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ClientInfo/"
	
	if Entity.get_entities_with("player").size() > 0:
		var player_id = Entity.get_entities_with("player").keys()[0]
		var player_pos = get_node("/root/World/" + str(player_id) + "/Player").translation.round()
		get_node(stats + "PlayerXYZ").text = "XYZ: " + str(player_pos)
		
		
		var normal = Player.get_looking_at_normal(player_id, OS.get_window_size() / 2)
		var block_location = Player.get_looking_at(player_id, OS.get_window_size() / 2)# - normal
		
		if normal == Vector3(0, 0, -1):
			block_location += Vector3(0, 1, 0)
		elif normal == Vector3(0, 0, 1):
			block_location += Vector3(0, 1, -1)
		elif normal == Vector3(-1, 0, 0):
			block_location += Vector3(0, 1, 0)
		elif normal == Vector3(1, 0, 0):
			block_location += Vector3(-1, 1, 0)
		elif normal == Vector3(0, -1, 0):
			block_location += Vector3(0, 1, 0)
		
		get_node(stats + "LookingXYZ").text = "Looking at: XYZ: " + str(block_location.round())
		
		var location = ChunkSystem.get_chunk(block_location)
		get_node(stats + "LookingAtChunk").text = "Looking at chunk: XYZ: " + str(location.round())
		
		var orentation = Player.get_orientation(player_id)
		get_node(stats + "Orentation").text = "Orentation: " + str(orentation)
		
		chunk_info_update(id, player_pos)

func action_mode_update(id):
	var stats = "/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ClientInfo/"
	get_node(stats + "Mode").text = "Mode: " + ClientSystem.action_mode

func frame_update(id):
	var stats = "/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ClientInfo/"
	
	get_node(stats + "Entities").text = "Entities: " + str(ClientSystem.total_entities) + " | Players: " + str(ClientSystem.total_players)
	get_node(stats + "AllBlocksLoaded").text = "Blocks Loaded: " + str(ClientSystem.blocks_loaded)
	get_node(stats + "BlocksFound").text = "Blocks Found: " + str(ClientSystem.blocks_found)
	get_node(stats + "FPS").text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))

func world_stats_update(id):
	var stats = "/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/WorldStats/"
	
	get_node(stats + "WorldName").text = "== " + ServerSystem.map_name + " =="
	get_node(stats + "WorldPath").text = ServerSystem.map_path
	
	get_node(stats + "TotalChunks").text = "Total Chunks: " + str(ServerSystem.total_chunks)
	get_node(stats + "ChunksCache").text = "Chunk Cache: " + str(ServerSystem.chunks_cache_size)
	get_node(stats + "ChunksLoaded").text = "Chunks Loaded: " + str(ClientSystem.chunk_index.size())
	get_node(stats + "Seed").text = "Seed: " + str(ServerSystem.map_seed)
	

func chunk_info_update(id, player_pos):
	var stats = "/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ChunkInfo/"
	
	var chunk = ChunkSystem.get_chunk(player_pos)
	
	var chunk_id = ChunkSystem.get_chunk_id(chunk)
	
	get_node(stats + "ChunkXYZ").text = "XYZ: " + str(chunk)
	
	if chunk_id:
		get_node(stats + "ChunkAddress").text = "== Chunk: " + str(Entity.get_component(chunk_id, "chunk.address")) + " =="
		get_node(stats + "BlocksLoaded").text = "Blocks Loaded: " + str(Entity.get_component(chunk_id, "chunk.blocks_loaded"))
		#get_node(stats + "Blocks").text = "Mode: " + ClientSystem.action_mode