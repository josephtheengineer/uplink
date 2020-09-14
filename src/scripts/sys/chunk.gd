extends Node
class_name ChunkSystem
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sys.chunk",
	description = """
		manages chunk data
	"""
}
#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	map = {
		map_file = null,
		chunk_locations = Dictionary(),
		chunk_addresses = Dictionary(),
		chunk_metadata = Array()
	},
	thread_busy = false,
	thread = null,
	destroyer_of_chunks = false
}
#warning-ignore:unused_class_variable
var data := DEFAULT_DATA

signal thread_completed

func _ready(): #################################################################
	#Core.emit_signal("function_started", "_ready()", meta)
	Core.connect("reset", self, "_reset")
	Core.connect("thread_completed", self, "_thread_completed")
	Core.emit_signal("system_ready", Core.scripts.core.system.CHUNK, self)             ##### READY #####	

func _process(_delta):
	#print(data.thread_busy)
	if data.thread and not data.thread_busy:
		if data.thread.is_active():
			data.thread.wait_to_finish()
		else:
			Core.scripts.chunk.thread.start_chunk_thread()

func _reset():
	data = DEFAULT_DATA


func _chunk_thread_process(userdata: Dictionary): ##############################
	Core.scripts.chunk.thread.discover_surrounding_chunks(Core.scripts.chunk.tools.get_chunk(userdata.player_position), 
		userdata.render_distance)
	Core.scripts.chunk.thread.process_chunks(userdata.chunks)
	data.thread_busy = false
