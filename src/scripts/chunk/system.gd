extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.system",
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
	discover = {
		busy = false,
		thread = null
	},
	process = {
		busy = false,
		thread = null
	},
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

# chunk.system._ready ##########################################################
const _ready_meta := {
	func_name = "chunk.system._ready",
	description = """
		
	""",
		}
func _ready(args := _ready_meta) -> void: ######################################
	#Core.emit_signal("function_started", "_ready()", meta)
	Core.connect("reset", self, "_reset")
	#Core.connect("thread_completed", self, "_thread_completed")
	if !Core.scripts.chunk.thread.MULTITHREADING:
		Core.emit_signal("msg", "Multithreading has been turnend off, game will be very slow when loading chunks!", Core.WARN, args)
	Core.emit_signal("system_ready", Core.scripts.core.system_manager.CHUNK, self)             ##### READY #####
# ^ chunk.system._ready ########################################################


# chunk.system._process ########################################################
const _process_meta := {
	func_name = "chunk.system._process",
	description = """
		
	""",
		}
func _process(delta, args := _process_meta) -> void: ###########################
	if data.discover.thread and not data.discover.busy:
		if data.discover.thread.is_active() or data.discover.busy:
			data.discover.thread.wait_to_finish()
		else:
			Core.scripts.chunk.thread.start_discover_thread()
	
	if data.process.thread and not data.process.busy:
		if data.process.thread.is_active() or data.process.busy:
			data.process.thread.wait_to_finish()
		else:
			Core.scripts.chunk.thread.start_process_thread()
# ^ chunk.system._process ######################################################


# chunk.system._reset ##########################################################
const _reset_meta := {
	func_name = "chunk.system._reset",
	description = """
		
	""",
		}
func _reset(args := _reset_meta) -> void: ######################################
	Core.emit_signal("msg", "Reseting chunk system database...", Core.DEBUG, args)
	data = DEFAULT_DATA.duplicate(true)
	#Core.world.get_node("Chunk").data.process.disabled = true
# ^ chunk.system._reset ########################################################


# chunk.system._discover_surrounding_chunks ####################################
const _discover_surrounding_chunks_meta := {
	func_name = "chunk.system._discover_surrounding_chunks",
	description = """
		
	""",
		}
func _discover_surrounding_chunks(_data, args := _discover_surrounding_chunks_meta) -> void: 
	Core.scripts.chunk.thread.discover_surrounding_chunks()
	data.discover.busy = false
# ^ chunk.system._discover_surrounding_chunks ##################################


# chunk.system._process_chunks #################################################
const _process_chunks_meta := {
	func_name = "chunk.system._process_chunks",
	description = """
		
	""",
		}
func _process_chunks(_data, args := _process_chunks_meta) -> void: #############
	Core.scripts.chunk.thread.process_chunks()
	data.process.busy = false
# ^ chunk.system._process_chunks ###############################################


# chunk.system.create ##########################################################
const create_meta := {
	func_name = "chunk.system.create",
	description = """
		
	""",
		entity = {},
		error = false}
func create(args := create_meta) -> void: ######################################
	if args.entity.meta.system != "chunk":
		Core.emit_signal("msg", "Chunk entity create called with incorrect system set", Core.WARN, args)
		args.error = "Chunk entity create called with incorrect system set"
		return
	
	if args.entity.meta.type == "chunk":
		var node = Entity.new()
		node.set_name(args.entity.meta.id)
		node.components = args.entity
		add_child(node)
		Core.scripts.chunk.manager.generate_chunk_components(node)
# ^ chunk.system.create ########################################################
