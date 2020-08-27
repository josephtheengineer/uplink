#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.debug.info",
	description = """
		
	"""
}

static func player_move_update(hud):
	var stats = "World/Interfaces/" + str(hud.components.id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ClientInfo/"
	
	if true: #Maanager.get_entities_with("Interfaces"):
		#var player_id = Entity.get_entities_with("player").keys()[0]
		var player_id = "JosephTheEngineer"
		var player = Core.get_parent().get_node("World/Inputs/" + str(player_id))
		
		var player_pos = player.get_node("Player").translation.round()
		Core.get_parent().get_node(stats + "PlayerXYZ").text = "XYZ: " + str(player_pos)
		
		
		var normal = Core.scripts.client.player.get_looking_at_normal(player, OS.get_window_size() / 2)
		var block_location = Core.scripts.client.player.get_looking_at(player, OS.get_window_size() / 2)# - normal
		
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
		
		Core.get_parent().get_node(stats + "LookingXYZ").text = "Looking at: XYZ: " + str(block_location.round())
		
		var location = Core.scripts.chunk.tools.get_chunk(block_location)
		Core.get_parent().get_node(stats + "LookingAtChunk").text = "Looking at chunk: XYZ: " + str(location.round())
		
		var orentation = Core.scripts.client.player.get_orientation(player)
		Core.get_parent().get_node(stats + "Orentation").text = "Orentation: " + str(orentation)
		
		chunk_info_update(hud, player_pos)

static func action_mode_update(hud):
	var stats = "World/Interfaces/" + str(hud.components.id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ClientInfo/"
	Core.get_parent().get_node(stats + "Mode").text = "Mode: " + Core.Client.action_mode

static func frame_update(hud):
	var stats = "World/Interfaces/" + str(hud.components.id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ClientInfo/"
	
	Core.get_parent().get_node(stats + "Entities").text = "Entities: " + str(Core.Client.total_entities) + " | Players: " + str(Core.Client.total_players)
	Core.get_parent().get_node(stats + "AllBlocksLoaded").text = "Blocks Loaded: " + str(Core.Client.blocks_loaded)
	Core.get_parent().get_node(stats + "BlocksFound").text = "Blocks Found: " + str(Core.Client.blocks_found)
	Core.get_parent().get_node(stats + "FPS").text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))

static func world_stats_update(hud):
	var stats = "World/Interfaces/" + str(hud.components.id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/WorldStats/"
	
	Core.get_parent().get_node(stats + "WorldName").text = "== " + Core.Server.map_name + " =="
	Core.get_parent().get_node(stats + "WorldPath").text = Core.Server.map_path
	
	Core.get_parent().get_node(stats + "TotalChunks").text = "Total Chunks: " + str(Core.Server.total_chunks)
	Core.get_parent().get_node(stats + "ChunksCache").text = "Chunk Cache: " + str(Core.Server.chunks_cache_size)
	#Core.get_parent().get_node(stats + "ChunksLoaded").text = "Chunks Loaded: " + str(Core.get_parent().get_node("World/Chunks").get_child_count())
	Core.get_parent().get_node(stats + "Seed").text = "Seed: " + str(Core.Server.map_seed)
	

static func chunk_info_update(hud, player_pos):
	var stats = "World/Interfaces/" + str(hud.components.id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/ChunkInfo/"
	
	var chunk_loc = Core.scripts.chunk.tools.get_chunk(player_pos)
	if Core.get_parent().has_node("World/Chunks"):
		if Core.get_parent().get_node("World/Chunks").has_node(str(chunk_loc)):
			var chunk = Core.get_parent().get_node("World/Chunks/" + str(chunk_loc))
			
			Core.get_parent().get_node(stats + "ChunkXYZ").text = "XYZ: " + str(chunk.components.position)
			Core.get_parent().get_node(stats + "ChunkAddress").text = "== Chunk: " + str(chunk.components.address) + " =="
			Core.get_parent().get_node(stats + "BlocksLoaded").text = "Blocks Loaded: " + str(chunk.components.blocks_loaded)
			#Core.get_parent().get_node(stats + "Blocks").text = "Blocks: " + Core.Client.action_mode
