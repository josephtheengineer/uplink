#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.spawn",
	type = "process",
	steps = [
		"request_spawn",
		"start_chunk_thread"
	],
	description = """
		
	"""
}

static func request_spawn():
	Core.emit_signal("system_process", meta, "request_spawn", "start")
	Core.client.data.players.append(Core.client.data.subsystem.input.Link.data.player)
	Core.server.spawn_player_at_default_pos(Core.client.data.subsystem.input.Link.data.player)
	Core.emit_signal("system_process", meta, "request_spawn", "success")

static func start_chunk_thread():
	Core.emit_signal("system_process", meta, "start_chunk_thread", "start")
	Core.scripts.chunk.thread.start_discover_thread()
	Core.scripts.chunk.thread.start_process_thread()
	#Core.scripts.chunk.helper.load_player_spawn_chunks()
	Core.emit_signal("system_process", meta, "start_chunk_thread", "success")
