#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.break_block",
	type = "process",
	steps = [
		"play_sound",
		"modify_chunk",
	],
	description = """
		breaks the selected block
		[input_player].looking_at
	"""
}

static func play_sound():
	Core.emit_signal("system_process", meta, "play_sound", "start")
	var music_player = AudioStreamPlayer3D.new()
	var audio = load("res://aux/assets/sounds/game/block_break_generic_1_v2.ogg")
	audio.loop = false
	music_player.stream = audio
	music_player.connect("finished", Core.client, "_stop_player", [music_player])
	Core.client.add_child(music_player)
	music_player.play()
	Core.emit_signal("system_process", meta, "play_sound", "success")

static func modify_chunk():
	Core.emit_signal("system_process", meta, "modify_chunk", "start")
	var player_name = Core.client.data.subsystem.input.Link.data.player
	var player = Core.world.get_node("Input/" + player_name)
	var chunk_location = player.components.looking_at.chunk
	var block_location = player.components.looking_at.block
	
	var final_pos = Core.scripts.chunk.tools.get_local_chunk_pos(block_location, chunk_location)
	Core.emit_signal("msg", "Breaking block at local " + str(chunk_location) + " pos " + str(final_pos), Core.DEBUG, meta)
	
	if !Core.world.has_node("Chunk/" + str(chunk_location)):
		Core.emit_signal("msg", "Invalid chunk!", Core.ERROR, meta)
		return
	
	var chunk = Core.world.get_node("Chunk/" + str(chunk_location))
	if player.components.action.resolution == 1:
		Core.scripts.chunk.modify.break_block(chunk, final_pos)
	else:
		Core.scripts.chunk.modify.break_voxel(chunk, final_pos.floor(), (block_location-block_location.floor()) * 16)
	Core.emit_signal("system_process", meta, "modify_chunk", "success")
