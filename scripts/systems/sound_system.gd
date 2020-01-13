extends Node
onready var Events = get_node("/root/Events")
onready var Debug = preload("res://scripts/features/debug.gd")
onready var SystemManager = preload("res://scripts/features/system_manager.gd").new()

var music_player = AudioStreamPlayer3D.new()
var playlist_progress = 0
var playlist = "Eden"

func _ready():
	Events.emit_signal("system_ready", SystemManager.SOUND)                ##### READY #####

func music_player_finished():
	if playlist == "Eden":
		if playlist_progress > 7:
			playlist_progress = 0
		
		var audio = load("res://sounds/music/eden" + str(playlist_progress) + ".ogg")
		audio.loop = false
		music_player.stream = audio
		
		#if playlist_progress != 7:
#			get_node("UI/Home/VBoxContainer/BottomContainer/VBoxContainer/Button/Song").text = "Eden " + str(playlist_progress) + " by Adam Gubman"
		#else:
				#get_node("UI/Home/VBoxContainer/BottomContainer/VBoxContainer/Button/Song").text = "Eden " + str(playlist_progress) + " by Vodlos"
		
	elif playlist == "Engineer":
		pass
	
	add_child(music_player)
	music_player.play()
	playlist_progress += 1

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
