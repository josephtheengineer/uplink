#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.helper",
	description = """
		
	"""
}

# chunk.helper.load_player_spawn_chunks ########################################
const load_player_spawn_chunks_meta := {
	func_name = "chunk.helper.load_player_spawn_chunks",
	description = """
		
	""",
		}
static func load_player_spawn_chunks(args := load_player_spawn_chunks_meta) -> void: 
	#var err: int = object.connect(signal_link, object, method)
	#if err:
		#Core.emit_signal("msg", "Error on binding to chunks_loaded"
		#	+ ": " + str(err), Core.WARN, meta)
	
	var player = Core.world.get_node("Input").get_children()[0].get_node("Player")
	
	var tools = Core.scripts.chunk.tools
	var player_chunk = tools.get_chunk(player.translation)
	
	for x in range(-1, 2):
		for y in range(10):
			for z in range(-1, 2):
				Core.scripts.chunk.manager.create_chunk(
					Vector3(
						player_chunk.x+x, 
						player_chunk.y-y, 
						player_chunk.z+z
					)
				)
	
	#var timer = Timer.new()
	#timer.connect("timeout", self, "_on_timer_timeout")
	#timer.wait_time = 10
	#Core.add_child(timer)
	#timer.start()
	#_on_timer_timeout(object)
# ^ chunk.helper.load_player_spawn_chunks ######################################


# chunk.helper._on_timer_timeout ###############################################
const _on_timer_timeout_meta := {
	func_name = "chunk.helper._on_timer_timeout",
	description = """
		
	""",
		}
static func _on_timer_timeout(object, args := _on_timer_timeout_meta) -> void: 
	object.emit_signal("chunks_loaded")
# ^ chunk.helper._on_timer_timeout #############################################
