#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.debug.info",
	description = """
		
	"""
}

static func player_move_update(hud):
	if Core.client.data.subsystem.input.Link:
		var player_id = Core.client.data.subsystem.input.Link.data.player
		if Core.world.has_node("Input/" + player_id):
			var player = Core.world.get_node("Input/" + str(player_id))
			
			var player_pos = player.get_node("Player").translation.floor()
			set_text(hud, "ClientInfo/PlayerXYZ", "XYZ: " + str(player_pos))
			
			
			#var normal = Core.scripts.client.player.interact.get_looking_at_normal(player, OS.get_window_size() / 2)
			var block_location = Core.scripts.client.player.interact.get_looking_at(player, OS.get_window_size() / 2)# - normal
			
			set_text(hud, "ClientInfo/LookingAtVoxel", "Looking at voxel: XYZ: " + str((block_location-block_location.floor())*16))
			
			set_text(hud, "ClientInfo/LookingAtBlock", "Looking at block: XYZ: " + str(block_location.floor()))
			
			var location = Core.scripts.chunk.tools.get_chunk(block_location)
			set_text(hud, "ClientInfo/LookingAtChunk", "Looking at chunk: XYZ: " + str(location.floor()))
			
			var orentation = Core.scripts.client.player.interact.get_orientation(player)
			set_text(hud, "ClientInfo/Orentation", "Orentation: " + str(orentation))
			
			chunk_info_update(hud, player_pos)

static func action_mode_update(hud):
	if Core.client.data.subsystem.input.Link:
		var player_id = Core.client.data.subsystem.input.Link.data.player
		if Core.world.has_node("Input/" + player_id):
			set_text(hud, "ClientInfo/Mode", "Mode: " + Core.world.get_node("Input/" + player_id).components.action.mode)

static func frame_update(hud):
	set_text(hud, "ClientInfo/Entities", "Entities: "             + str(Core.client.data.total_entities) + " | Players: " + str(Core.client.data.total_players))
	set_text(hud, "ClientInfo/AllBlocksLoaded", "Blocks Loaded: " + str(Core.client.data.blocks_loaded)                                                        )
	set_text(hud, "ClientInfo/BlocksFound", "Blocks Found: "      + str(Core.client.data.blocks_found)                                                         )
	set_text(hud, "ClientInfo/FPS", "FPS: "                       + str(Performance.get_monitor(Performance.TIME_FPS))                                         )

static func world_stats_update(hud):
	set_text(hud, "WorldStats/WorldName", "== " + Core.server.data.map.name + " ==")
	set_text(hud, "WorldStats/WorldPath",         Core.server.data.map.path        )
	
	set_text(hud, "WorldStats/TotalChunks", "Total Chunks: " + str(Core.server.data.map.total_chunks)     )
	set_text(hud, "WorldStats/ChunksCache", "Chunk Cache: "  + str(Core.server.data.map.chunks_cache_size))
	#Core.get_parent().get_node(stats + "ChunksLoaded").text = "Chunks Loaded: " + str(Core.get_parent().get_node("World/Chunks").get_child_count())
	set_text(hud, "WorldStats/Seed", "Seed: " + str(Core.server.data.map.seed))
	

static func chunk_info_update(hud, player_pos):
	var chunk_loc = Core.scripts.chunk.tools.get_chunk(player_pos)
	if Core.world.get_node("Chunk").has_node(str(chunk_loc)):
		var chunk = Core.world.get_node("Chunk/" + str(chunk_loc))
		
		set_text(hud, "ChunkInfo/ChunkXYZ",     "XYZ: "           + str(chunk.components.position.world)       )
		set_text(hud, "ChunkInfo/ChunkAddress", "== Chunk: "      + str(chunk.components.position.address) + " ==")
		set_text(hud, "ChunkInfo/BlocksLoaded", "Blocks Loaded: " + str(chunk.components.mesh.blocks_loaded)  )
		#Core.get_parent().get_node(stats + "Blocks").text = "Blocks: " + Core.Client.action_mode
	else:
		set_text(hud, "ChunkInfo/ChunkXYZ",     "XYZ: "           + str(chunk_loc))
		set_text(hud, "ChunkInfo/ChunkAddress", "== Chunk: "      + "N/A" + " ==" )
		set_text(hud, "ChunkInfo/BlocksLoaded", "Blocks Loaded: " + "N/A"         )

static func set_text(hud: Entity, key: String, value: String):
	var label: Label = Core.world.get_node("Interface/" + str(hud.components.meta.id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/DebugStats/" + key)
	label.text = value
