extends Node
class_name ServerSystem
#warning-ignore:unused_class_variable
const script_name := "server_system"
onready var Debug := preload("res://scripts/features/debug.gd").new()
onready var Entity := preload("res://scripts/features/entity.gd").new()
onready var EdenWorldDecoder := preload("res://scripts/features/eden_world_decoder.gd").new()
onready var SystemManager := preload("res://scripts/features/system_manager.gd").new()

################################################################################

#warning-ignore:unused_class_variable
var map_seed := 0
#warning-ignore:unused_class_variable
var map_path := "user://worlds/videogame-museum.eden2"
#var map_path := "user://worlds/direct_city.eden2"
#var map_path := "user://worlds/jte_test_world.eden2"
#warning-ignore:unused_class_variable
var map_name := "Videogame Museum"

#warning-ignore:unused_class_variable
var last_location := Vector3(0, 0, 0)
#warning-ignore:unused_class_variable
var home_location := Vector3(0, 0, 0)
#warning-ignore:unused_class_variable
var home_rotation := 0

#warning-ignore:unused_class_variable
var chunks_cache_size := 0
#warning-ignore:unused_class_variable
var total_chunks := 0

#warning-ignore:unused_class_variable
var map_file := File.new()
#warning-ignore:unused_class_variable
var chunk_metadata := Dictionary()
#warning-ignore:unused_class_variable
var regions := Dictionary()

#warning-ignore:unused_class_variable
var worldAreaX := 0
#warning-ignore:unused_class_variable
var worldAreaY := 0
#warning-ignore:unused_class_variable
var world_width := 0
#warning-ignore:unused_class_variable
var world_height := 0

################################################################################

func _ready(): #################################################################
	#create_world()
	Core.emit_signal("system_ready", SystemManager.SERVER, self)            ##### READY #####


func create_world(): ###########################################################
	# Needs to create chunk data but not chunk render
	# Core.Client.Chunk.create_chunk(Vector3(0, 0, 0))
	pass


func create_server(username: String): ##########################################
	Core.emit_signal("msg", "Creating server...", Debug.INFO, self)
	var network = NetworkedMultiplayerENet.new()
	network.create_server(8888, 100)
	get_tree().set_network_peer(network)
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	get_tree().set_meta("network_peer", network)


func _peer_connected(id: int): #################################################
	Core.emit_signal("msg", "User " + str(id) + " connected", Debug.INFO, 
		self)
	
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Debug.INFO, self)


func _peer_disconnected(id: int): ##############################################
	Core.emit_signal("msg", "User " + str(id) + " disconnected", 
		Debug.INFO, self)
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Debug.INFO, self)


signal world_loaded
func load_world(object: Object, method: String):
	var error := connect("world_loaded", object, method)
	if error:
		emit_signal("msg", "Error on binding to world_loaded: " 
			+ str(error), Debug.WARN, self)
	
	Core.emit_signal("msg", "Loading world...", Debug.INFO, self)
	Core.emit_signal("msg", "Running demo preset...", Debug.INFO, self)
	Core.emit_signal("msg", "Removing all entities...", Debug.DEBUG, self)
	#for id in Entity.objects:
		#Entity.destory(id)
	
	EdenWorldDecoder.load_world()
	Core.emit_signal("msg", "Spawning player at last known location: " 
		+ str(last_location), Debug.DEBUG, self)
	
	var chunk_position = Core.Client.ChunkSystem.get_chunk(last_location)
	chunk_position.y = 0
	Core.Client.spawn_player(last_location)
	
	Core.emit_signal("msg", "Chunk: " + str(chunk_position), Debug.DEBUG, 
		self)
	
	#Core.emit_signal("msg", str(EdenWorldDecoder.get_chunk_data(chunk_position)), Debug.TRACE, self)
	Core.Client.ChunkSystem.create_chunk(Vector3(0, 0, 0))
	emit_signal("world_loaded")
