extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sound.system",
	description = """
		
	"""
}
#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	music_player = null,
	playlist_progress = 0,
	playlist = "Eden"
}
var data := DEFAULT_DATA.duplicate(true)

func _ready():
	Core.connect("reset", self, "_reset")
	#var audio = AudioStreamPlayer3D.new()
	#audio.
	Core.emit_signal("system_ready", Core.scripts.core.system_manager.SOUND, self)                ##### READY #####

func _reset():
	Core.emit_signal("msg", "Reseting sound system database...", Core.DEBUG, meta)
	data = DEFAULT_DATA.duplicate(true)

func music_player_finished():
	if data.playlist == "Eden":
		if data.playlist_progress > 7:
			data.playlist_progress = 0
		
		var audio = load("res://sounds/music/eden" + str(data.playlist_progress) + ".ogg")
		audio.loop = false
		data.music_player.stream = audio
		
		#if playlist_progress != 7:
#			get_node("UI/Home/VBoxContainer/BottomContainer/VBoxContainer/Button/Song").text = "Eden " + str(playlist_progress) + " by Adam Gubman"
		#else:
				#get_node("UI/Home/VBoxContainer/BottomContainer/VBoxContainer/Button/Song").text = "Eden " + str(playlist_progress) + " by Vodlos"
		
	elif data.playlist == "Engineer":
		pass
	
	add_child(data.music_player)
	data.music_player.play()
	data.playlist_progress += 1

#func _process(delta):
	#music_player.translation = Vector3(8, 8, 0)
	#_music_player_finished()
	
	#if get_node("UI").rect_position.x < snaped_position.x:
	#	get_node("UI").rect_position.x += distance_to_move_sub.x
	#	music_player.translation.x += distance_to_move_sub.x / 100
	#	distance_moved.x += distance_to_move_sub.x
	#else:
	#	get_node("UI").rect_position.x -= distance_to_move_sub.x
	#	music_player.translation.x -= distance_to_move_sub.x / 100
	#	distance_moved.x -= distance_to_move_sub.x
	
	#if get_node("UI").rect_position.y < snaped_position.y:
	#	get_node("UI").rect_position.y += distance_to_move_sub.y
	#	music_player.translation.y += distance_to_move_sub.y / 100
	#	distance_moved.y += distance_to_move_sub.y
	#else:
	#	get_node("UI").rect_position.y -= distance_to_move_sub.y
	#	music_player.translation.y -= distance_to_move_sub.y / 100
	#	distance_moved.y -= distance_to_move_sub.y

#func _skip_song():
	#_music_player_finished()

#func stop_player(player):
	#player.stop()
	#player.queue_free()
