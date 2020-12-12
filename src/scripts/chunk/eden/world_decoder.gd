#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.eden.world_decoder",
	description = """
		<3 JosephTheEngineer
		Based on code from Vuenctools for Eden || http://forum.edengame.net/index.php?/topic/295-vuenctools-for-eden-eden-world-manipulation-tool/
		with help from Robert Munafo || http://www.mrob.com/pub/vidgames/eden-file-format.html
	"""
}

# chunk.eden.world_decoder.create_world ########################################
const create_world_meta := {
	func_name = "chunk.eden.world_decoder.create_world",
	description = """
		
	""",
		error = ""}
static func create_world(args := create_world_meta) -> void: ###################
	Core.emit_signal("msg", "We are online. Starting eden2 world file creation...", Core.INFO, args)
	
	if Core.server.data.map.path == null:
		Core.emit_signal("msg", "InitializeWorld: WorldPath is null", Core.ERROR, args)
		args.error = "InitializeWorld: WorldPath is null"
		return
	else:
		Core.emit_signal("msg", "WorldPath is: " + Core.server.data.map.path, Core.INFO, args)
# ^ chunk.eden.world_decoder.create_world ######################################


# chunk.eden.world_decoder.load_world ##########################################
const load_world_meta := {
	func_name = "chunk.eden.world_decoder.load_world",
	description = """
		
	""",
		error = ""}
static func load_world(args := load_world_meta) -> void: #######################
	Core.emit_signal("msg", "We are online. Starting eden2 world file loading...", Core.INFO, args)
	var map = Core.server.data.map
	
	if map.path == null:
		Core.emit_signal("msg", "InitializeWorld: WorldPath is null", Core.ERROR, args)
		args.error = "InitializeWorld: WorldPath is null"
		return
	else:
		Core.emit_signal("msg", "WorldPath is: " + map.path, Core.INFO, args)
	
	if not map.file:
		map.file = File.new()
	
	if not map.file.file_exists(map.path):
		Core.emit_signal("msg", "World file does not exist!", Core.WARN, args)
		Core.emit_signal("msg", "Creating file " +map.path, Core.INFO, args)
		args.error = create_world()
		return
	elif map.file.open(map.path, File.READ) != 0:
		Core.emit_signal("msg", "Error opening file", Core.ERROR, args)
		args.error = "Error opening file"
		return
	elif read_int(0) == null:
		Core.emit_signal("msg", "Couldn't open input file for reading", Core.ERROR, args)
		args.error = "Couldn't open input file for reading"
		return
	
	# Check if world file is compressed
	map.file.seek(0)
	if map.file.get_buffer(1)[0] == 0x1f and map.file.get_buffer(2)[0] == 0x8b:
		Core.emit_signal("msg", "Map file is compressed... Decompressing", Core.DEBUG, args)
		if map.file.open_compressed(map.path, File.READ, File.COMPRESSION_GZIP) != 0:
			Core.emit_signal("msg", "Error opening file", Core.ERROR, args)
			args.error = "Error opening file"
			return
	else:
		Core.emit_signal("msg", "Map file is uncompressed", Core.DEBUG, args)
		if map.file.open(map.path, File.READ) != 0:
			Core.emit_signal("msg", "Error opening file", Core.ERROR, args)
			args.error = "Error opening file"
			return
	
	Core.emit_signal("msg", "File is loaded! Length is " + str(map.file.get_len()), Core.INFO, args)
	
	args.error = get_metadata()
	return
# ^ chunk.eden.world_decoder.load_world ########################################


static func read_int(position: int): ###########################################
	Core.Server.data.map.file.seek(position)
	return Core.server.data.map.file.get_buffer(1)[0]


static func read_float(position: int): #########################################
	Core.Server.data.map.file.seek(position)
	return Core.server.data.map.file.get_float()


# chunk.eden.world_decoder.get_metadata ########################################
const get_metadata_meta := {
	func_name = "chunk.eden.world_decoder.get_metadata",
	description = """
		
	""",
		error = ""}
static func get_metadata(args := get_metadata_meta) -> void: ###################
	var map = Core.server.data.map
	var chunk_pointer: int = read_int(35) * 256 * 256 * 256 + read_int(34) * 256 * 256 + read_int(33) * 256 + read_int(32)
	Core.emit_signal("msg", "Chunk Pointer: " + str(chunk_pointer), Core.DEBUG, args)
	Core.emit_signal("msg", "Float:" + str(read_float(4)), Core.DEBUG, args)
	map.last_location = Vector3(read_float(4), read_float(8), read_float(12))
	map.home.location = Vector3(read_float(16), read_float(20), read_float(24))
	map.home.rotation = read_float(28)
	
	Core.emit_signal("msg", "World file path is vaid. All systems are go for launch.", Core.INFO, args)
	map.size = Vector2(0, 0)
	while chunk_pointer + 11 < map.file.get_len():
		# Find chunk address
		var address: int = read_int(chunk_pointer + 11) * 256 * 256 * 256 + read_int(chunk_pointer + 10) * 256 * 256 + read_int(chunk_pointer + 9) * 256 + read_int(chunk_pointer + 8)
		# Find the position of the chunk
		var x: int = (read_int(chunk_pointer + 1) * 256 + read_int(chunk_pointer))
		
		var y: int = (read_int(chunk_pointer + 5) * 256 + read_int(chunk_pointer + 4))
		
		if map.area.x > x:
			map.area.x = x
		if Core.Server.data.map.area.y > y:
			map.area.y = y
		
		if Core.Server.data.map.size.x < x:
			map.size.x = x
		if Core.Server.data.map.size.y < y:
			map.size.y = y
		
		var chunk_data  = {
			"address": address, 
			"x": x, 
			"y": y, 
		}
		
		map.chunk_metadata[Vector3(x, 0, y)] = (chunk_data)
		map.chunk_metadata[Vector3(x, 1, y)] = (chunk_data)
		map.chunk_metadata[Vector3(x, 2, y)] = (chunk_data)
		map.chunk_metadata[Vector3(x, 3, y)] = (chunk_data)
		
		var region_loc := Vector3(floor(float(x)/16), floor(float(0)/16), floor(float(y)/16))
		
		if !map.regions.has(region_loc):
			Core.emit_signal("msg", "New region found! " + str(region_loc), Core.INFO, args)
			map.regions[region_loc] = []
		
		map.regions[region_loc].append(Vector3(x, 0, y))
		
		chunk_pointer += 16
	
	Core.emit_signal("msg", "Found " + str(map.chunk_metadata.size()) + " chunks", Core.INFO, args)
	#Core.emit_signal("msg", str(Core.Server.chunk_metadata), Core.TRACE, meta)
	map.total_chunks = map.chunk_metadata.size()
	
	# Get the total world width | max - min + 1
	map.size.x = map.size.x - map.area.x + 1;
	# Get the total world height | max - min + 1
	map.size.y = map.size.y - map.area.y + 1;
	Core.emit_signal("msg", "World size: " + str(map.size), Core.INFO, args)
	
	if map.chunk_metadata.size() < 1:
		Core.emit_signal("msg", "GetWorldMetadata: ChunkLocations was null!", Core.ERROR, args);
		args.error = "GetWorldMetadata: ChunkLocations was null!"
		return;
	return;
# ^ chunk.eden.world_decoder.get_metadata ######################################


# chunk.eden.world_decoder.get_chunk_data ######################################
const get_chunk_data_meta := {
	func_name = "chunk.eden.world_decoder.get_chunk_data",
	description = """
		
	""",
		error = "",
		location = Vector3(0, 0, 0),
		data = {}}
static func get_chunk_data(args := get_chunk_data_meta) -> void: ###############
	var map = Core.server.data.map
	if map.chunk_metadata.size() < 0:
		Core.emit_signal("msg", "Invaild world data!", Core.ERROR, args);
		args.error = "Invaild world data!"
		return
	if !map.chunk_metadata.has(args.location):
		Core.emit_signal("msg", "Chunk data does not exist! " + str(args.location), Core.TRACE, args);
		args.error = "Chunk data does not exist!"
		return
	
	var chunk_data := Dictionary()
	var chunk_address: int = map.chunk_metadata[args.location].address
	Core.emit_signal("msg", "Chunk Address: " + str(chunk_address), Core.DEBUG, args)
	
	var baseHeight := int(args.location.y)
	for x in range(16):
		for y in range(16):
			for z in range(16):
				var id = read_int(chunk_address + baseHeight * 8192 + x * 256 + y * 16 + z)
				var color = read_int(chunk_address + baseHeight * 8192 + x * 256 + y * 16 + z + 4096)
				
				#var RealX = (x + (location.x*16))
				#var RealY = (y + (location.z*16))
				#var RealZ = (z + (16 * baseHeight))
				
				#var position = Vector3(x, z + 16 * baseHeight, y)
				var position := Vector3(x, z, y)
				
				#Logger.LogInt("=== Id: ", Id, " ===", Core.DEBUG, args);
				#Logger.LogInt("Color: ", Color, "", Core.DEBUG, args);
				#Logger.LogFloat("X: ", (x + (globalChunkPosX*16)) * 100, "", Core.DEBUG, args);
				#Logger.LogFloat("Y: ", (y + (globalChunkPosY*16)) * 100, "", Core.DEBUG, args);
				#Logger.LogFloat("Z: ", (z + (16 * baseHeight)) * 100, "", Core.DEBUG, args);
				
				if id != 0 && id <= 79 && id > 0:
					# Logger.Log("Block is valid", Core.DEBUG, args);
					#Core.emit_signal("msg", id, Core.TRACE, args)
					var block_data := {
						"id": id, 
						"color": color
					}
					
					chunk_data[position] = block_data;
					#Core.emit_signal("msg", ["id: ", id], Core.TRACE, args)
					#Core.emit_signal("msg", ["Adding Block ", chunk_data.size()], Core.DEBUG, args);
				#Core.emit_signal("msg", ["Chunk data tmp: ", chunk_data.size(), " blocks"], Core.DEBUG, args);
	Core.emit_signal("msg", str("Chunk data contains ", chunk_data.size(), " blocks"), Core.DEBUG, args);
	args.data = chunk_data;
# ^ chunk.eden.world_decoder.get_chunk_data ####################################
