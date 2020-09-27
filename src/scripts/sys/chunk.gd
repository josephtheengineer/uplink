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
	destroyer_of_chunks = false,
	mem_max = false
}
#warning-ignore:unused_class_variable
var data := DEFAULT_DATA.duplicate(true)

const RES_1 = 1         # 1    (1000mm) # Potato
const RES_2 = 16        # 16   (62.5mm) # Toaster (Eden/Minecraft) (Mobile)
const RES_3 = RES_2*2   # 32   (31.25mm) # Low (Double res)
const RES_4 = RES_3*2   # 64   (15.625mm) # Medium (Quad res)
const RES_5 = RES_4*2   # 128  ( 7.8125mm) 
const RES_6 = RES_5*2   # 256  ( 3.90625mm)
const RES_7 = RES_6*2   # 512  ( 1.953125mm) # Ultra (SD) (Laptop)
const RES_8 = RES_7*2   # 1024 ( 0.9765625mm) # God (HD) (PC)
const RES_9 = RES_8*2   # 2048 ( 0.48828125mm) (2K) (Size of PCB traces)
const RES_10 = RES_9*2  # 4096 ( 0.244140625mm) # Super computer (4K)
const RES_11 = RES_10*2 # 8192 ( 0.1220703125mm) (8K)
const RES_12 = RES_11*2 # 16384( 0.06103515625mm) # The matrix (iPhone dpi) (16K)

const DEFAULT_VOXEL_RES = RES_2
var voxel_res = DEFAULT_VOXEL_RES

signal thread_completed

func _ready(): #################################################################
	#Core.emit_signal("function_started", "_ready()", meta)
	Core.connect("reset", self, "_reset")
	#Core.connect("thread_completed", self, "_thread_completed")
	Core.emit_signal("system_ready", Core.scripts.core.system.CHUNK, self)             ##### READY #####

func _process(_delta):
	if data.thread and not data.thread_busy:
		if data.thread.is_active() or data.thread_busy:
			data.thread.wait_to_finish()
		else:
			Core.scripts.chunk.thread.start_chunk_thread()

func _reset():
	Core.emit_signal("msg", "Reseting chunk system database...", Core.DEBUG, meta)
	data = DEFAULT_DATA.duplicate()


func _chunk_thread_process(_data): ##################################################
	# Create chunk nodes
	Core.scripts.chunk.thread.discover_surrounding_chunks()
	
	# Render meshes for chunk nodes
	Core.scripts.chunk.thread.process_chunks()
	data.thread_busy = false

func create(entity: Dictionary):
	if entity.meta.system != "chunk":
		Core.emit_signal("msg", "Chunk entity create called with incorrect system set", Core.WARN, meta)
		return false
	
	if entity.meta.type == "chunk":
		var node = Entity.new()
		node.set_name(entity.meta.id)
		node.components = entity
		add_child(node)
		Core.scripts.chunk.manager.generate_chunk_components(node)
