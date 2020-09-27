#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.helper",
	description = """
		
	"""
}

#static func init_chunk(id: int): ##############################################
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


static func load_player_spawn_chunks(): ########################################
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

static func _on_timer_timeout(object):
	object.emit_signal("chunks_loaded")
