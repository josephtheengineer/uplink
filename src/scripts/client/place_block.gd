#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.place_block",
	type = "process",
	steps = [
		"play_sound",
		"modify_chunk",
	],
	description = """
		places the selected block
		[input_player].looking_at
	"""
}

static func play_sound():
	Core.emit_signal("system_process", meta, "play_sound", true)
	var music_player = AudioStreamPlayer3D.new()
	var audio = load("res://aux/assets/sounds/game/block_break_generic_1_v2.ogg")
	audio.loop = false
	music_player.stream = audio
	music_player.connect("finished", Core.client, "_stop_player", [music_player])
	Core.client.add_child(music_player)
	music_player.play()
	Core.emit_signal("system_process", meta, "play_sound")

static func modify_chunk():
	Core.emit_signal("system_process", meta, "modify_chunk", true)
	var player_name = Core.Client.data.subsystem.input.Link.data.player
	var player = Core.get_parent().get_node("World/Inputs/" + player_name)
	var chunk_location = player.components.looking_at_chunk
	var block_location = player.components.looking_at_block
	
	var final_pos = Core.scripts.chunk.tools.get_local_chunk_pos(block_location, chunk_location)
	Core.emit_signal("msg", "Placing block at local " + str(chunk_location) + " pos " + str(final_pos), Core.DEBUG, meta)
	
	if !Core.get_parent().has_node("World/Chunks/" + str(chunk_location)):
		Core.emit_signal("msg", "Invalid chunk!", Core.ERROR, meta)
		return
	
	var chunk = Core.get_parent().get_node("World/Chunks/" + str(chunk_location))
	Core.scripts.chunk.modify.place_block(chunk, final_pos, 8)
	Core.emit_signal("system_process", meta, "modify_chunk")
