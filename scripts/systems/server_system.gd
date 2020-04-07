extends Node
var Debug = load("res://scripts/features/debug.gd")
var Entity = load("res://scripts/features/entity.gd")
var EdenWorldDecoder = load("res://scripts/features/eden_world_decoder.gd")
onready var ChunkSystem = get_node("/root/World/Systems/Chunk")

var map_seed = 0
var map_path = "user://worlds/direct_city.eden2"
#var map_path = "user://worlds/jte_test_world.eden2"
var map_name = "direct_city.eden2"

var last_location = Vector3(0, 0, 0)
var home_location = Vector3(0, 0, 0)
var home_rotation = 0

var chunks_cache_size = 0
var total_chunks = 0

func start():
	#create_world()
	Debug.msg("Server System ready.", "Info")

func create_world():
	# Needs to create chunk data but not chunk render
	# ChunkSystem.create_chunk(Vector3(0, 0, 0))
	pass

func create_server(username): #################################################
	Debug.msg("Creating server...", "Info")
	var network = NetworkedMultiplayerENet.new()
	network.create_server(8888, 100)
	get_tree().set_network_peer(network)
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	get_tree().set_meta("network_peer", network)

func _peer_connected(id): #####################################################
	Debug.msg("User " + str(id) + " connected", "Info")
	Debug.msg("Total users: " + str(get_tree().get_network_connected_peers().size()), "Info")


func _peer_disconnected(id): ##################################################
	Debug.msg("User " + str(id) + " disconnected", "Info")
	Debug.msg("Total users: " + str(get_tree().get_network_connected_peers().size()), "Info")

signal world_loaded

func load_world(object, method):
	connect("world_loaded", object, method)
	Debug.msg("Loading world...", "Info")
	Debug.msg("Running demo preset...", "Info")
	Debug.msg("Removing all entities...", "Debug")
	for id in Entity.objects:
		Entity.destory(id)
	
	EdenWorldDecoder.load_world()
	Debug.msg("Spawning player at last known location: " + str(last_location), "Debug")
	var chunk_position = ChunkSystem.get_chunk(last_location)
	chunk_position.y = 0
	Debug.msg("Chunk: " + str(chunk_position), "Debug")
	
	Debug.msg(str(EdenWorldDecoder.get_chunk_data(chunk_position)), "Trace")
	ChunkSystem.create_chunk(Vector3(0, 0, 0))
	emit_signal("world_loaded")