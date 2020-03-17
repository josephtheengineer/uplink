# By JosephTheEngineer ¯\_(ツ)_/¯
# Based on code from Vuenctools for Eden || http://forum.edengame.net/index.php?/topic/295-vuenctools-for-eden-eden-world-manipulation-tool/
# with help from Robert Munafo || http://www.mrob.com/pub/vidgames/eden-file-format.html

var script_name = "eden_world_decoder"
var Debug = preload("res://scripts/features/debug.gd").new()

################################## functions ##################################

func create_world():
	Core.emit_signal("msg", "We are online. Starting eden2 world file creation...", Debug.INFO, self)
	
	if Core.Server.map_path == null:
		Core.emit_signal("msg", "InitializeWorld: WorldPath is null", Debug.ERROR, self)
		return false
	else:
		Core.emit_signal("msg", "WorldPath is: " + Core.Server.map_path, Debug.INFO, self)

func load_world(): ############################################################
	Core.emit_signal("msg", "We are online. Starting eden2 world file loading...", Debug.INFO, self)
	
	if Core.Server.map_path == null:
		Core.emit_signal("msg", "InitializeWorld: WorldPath is null", Debug.ERROR, self)
		return false
	else:
		Core.emit_signal("msg", "WorldPath is: " + Core.Server.map_path, Debug.INFO, self)
	
	if not Core.Server.map_file.file_exists(Core.Server.map_path):
		Core.emit_signal("msg", "World file does not exist!", Debug.WARN, self)
		Core.emit_signal("msg", "Creating file " + Core.Server.map_path, Debug.INFO, self)
		return create_world()
	elif Core.Server.map_file.open(Core.Server.map_path, File.READ) != 0:
		Core.emit_signal("msg", "Error opening file", Debug.ERROR, self)
		return false
	elif read_int(0) == null:
		Core.emit_signal("msg", "Couldn't open input file for reading", Debug.ERROR, self)
		return false
	
	# Check if world file is compressed
	Core.Server.map_file.seek(0)
	if Core.Server.map_file.get_buffer(1)[0] == 0x1f and Core.Server.map_file.get_buffer(2)[0] == 0x8b:
		Core.emit_signal("msg", "Map file is compressed... Decompressing", Debug.DEBUG, self)
		if Core.Server.map_file.open_compressed(Core.Server.map_path, File.READ, File.COMPRESSION_GZIP) != 0:
			Core.emit_signal("msg", "Error opening file", Debug.ERROR, self)
			return false
	else:
		Core.emit_signal("msg", "Map file is uncompressed", Debug.DEBUG, self)
		if Core.Server.map_file.open(Core.Server.map_path, File.READ) != 0:
			Core.emit_signal("msg", "Error opening file", Debug.ERROR, self)
			return false
	
	Core.emit_signal("msg", "File is loaded! Length is " + str(Core.Server.map_file.get_len()), Debug.INFO, self)
	
	return get_metadata()


func open_urw_file():
	pass


func open_eden2_gzip_file():
	pass

func open_eden2_file():
	pass

func open_eden1_gzip_file():
	pass

func open_eden1_file():
	pass

func read_int(position): ######################################################
	Core.Server.map_file.seek(position)
	var buffer = Core.Server.map_file.get_buffer(1)
	return buffer[0]

func read_float(position): ####################################################
	Core.Server.map_file.seek(position)
	return Core.Server.map_file.get_float()


func get_metadata(): ##########################################################
	var chunk_pointer = read_int(35) * 256 * 256 * 256 + read_int(34) * 256 * 256 + read_int(33) * 256 + read_int(32)
	Core.emit_signal("msg", "Chunk Pointer: " + str(chunk_pointer), Debug.DEBUG, self)
	Core.emit_signal("msg", "Float:" + str(read_float(4)), Debug.DEBUG, self)
	Core.Server.last_location = Vector3(read_float(4), read_float(8), read_float(12))
	Core.Server.home_location = Vector3(read_float(16), read_float(20), read_float(24))
	Core.Server.home_rotation = read_float(28)
	
	
	Core.emit_signal("msg", "World file path is vaid. All systems are go for launch.", Debug.INFO, self)
	Core.Server.world_width = 0
	Core.Server.world_height = 0
	while chunk_pointer + 11 < Core.Server.map_file.get_len():
		# Find chunk address
		var address = read_int(chunk_pointer + 11) * 256 * 256 * 256 + read_int(chunk_pointer + 10) * 256 * 256 + read_int(chunk_pointer + 9) * 256 + read_int(chunk_pointer + 8)
		# Find the position of the chunk
		var x = (read_int(chunk_pointer + 1) * 256 + read_int(chunk_pointer))
		
		var y = (read_int(chunk_pointer + 5) * 256 + read_int(chunk_pointer + 4))
		
		if Core.Server.worldAreaX > x:
			Core.Server.worldAreaX = x
		if Core.Server.worldAreaY > y:
			Core.Server.worldAreaY = y
		
		if Core.Server.world_width < x:
			Core.Server.world_width = x
		if Core.Server.world_height < y:
			Core.Server.world_height = y
		
		var chunk_data  = {
			"address": address, 
			"x": x, 
			"y": y, 
		}
		
		Core.Server.chunk_metadata[Vector3(x, 0, y)] = (chunk_data)
		Core.Server.chunk_metadata[Vector3(x, 1, y)] = (chunk_data)
		Core.Server.chunk_metadata[Vector3(x, 2, y)] = (chunk_data)
		Core.Server.chunk_metadata[Vector3(x, 3, y)] = (chunk_data)
		
		chunk_pointer += 16
	
	
	Core.emit_signal("msg", "Found " + str(Core.Server.chunk_metadata.size()) + " chunks", Debug.INFO, self);
	#Core.emit_signal("msg", str(Core.Server.chunk_metadata), Debug.TRACE, self)
	Core.Server.total_chunks = Core.Server.chunk_metadata.size()
	
	# Get the total world width | max - min + 1
	Core.Server.world_width = Core.Server.world_width - Core.Server.worldAreaX + 1;
	Core.emit_signal("msg", "World width: " + str(Core.Server.world_width), Debug.INFO, self)
	
	# Get the total world height | max - min + 1
	Core.Server.world_height = Core.Server.world_height - Core.Server.worldAreaY + 1;
	Core.emit_signal("msg", "World height: " + str(Core.Server.world_height), Debug.INFO, self)
	
	if Core.Server.chunk_metadata.size() < 1:
		Core.emit_signal("msg", "GetWorldMetadata: ChunkLocations was null!", Debug.ERROR, self);
		return false;
	return true;


func get_chunk_data(location): ################################################
	if Core.Server.chunk_metadata.size() < 0:
		Core.emit_signal("msg", "Invaild world data!", Debug.ERROR, self);
		return false
	if !Core.Server.chunk_metadata.has(location):
		#var chunks_map = Core.Server.chunk_metadata
		Core.emit_signal("msg", "Chunk data does not exist! " + str(location), Debug.WARN, self);
		return false
	
	var chunk_data = Dictionary()
	var chunk_address = Core.Server.chunk_metadata[location].address
	#Core.emit_signal("msg", "Chunk Address: " + str(chunk_address), Debug.DEBUG, self)
	
	var baseHeight = location.y
	for x in range(16):
		for y in range(16):
			for z in range(16):
				var id = read_int(chunk_address + baseHeight * 8192 + x * 256 + y * 16 + z)
				var color = read_int(chunk_address + baseHeight * 8192 + x * 256 + y * 16 + z + 4096)
				
				var RealX = (x + (location.x*16))
				var RealY = (y + (location.z*16))
				var RealZ = (z + (16 * baseHeight))
				
				#var position = Vector3(x, z + 16 * baseHeight, y)
				var position = Vector3(x, z, y)
				
				#Logger.LogInt("=== Id: ", Id, " ===", Debug.DEBUG, self);
				#Logger.LogInt("Color: ", Color, "", Debug.DEBUG, self);
				#Logger.LogFloat("X: ", (x + (globalChunkPosX*16)) * 100, "", Debug.DEBUG, self);
				#Logger.LogFloat("Y: ", (y + (globalChunkPosY*16)) * 100, "", Debug.DEBUG, self);
				#Logger.LogFloat("Z: ", (z + (16 * baseHeight)) * 100, "", Debug.DEBUG, self);
				
				if id != 0 && id <= 79 && id > 0:
					# Logger.Log("Block is valid", Debug.DEBUG, self);
					#Core.emit_signal("msg", id, Debug.TRACE, self)
					var block_data  = {
						"id": id, 
						"color": color
					}
					
					chunk_data[position] = block_data;
					#Core.emit_signal("msg", ["id: ", id], Debug.TRACE, self)
					#Core.emit_signal("msg", ["Adding Block ", chunk_data.size()], Debug.DEBUG, self);
				#Core.emit_signal("msg", ["Chunk data tmp: ", chunk_data.size(), " blocks"], Debug.DEBUG, self);
	#Core.emit_signal("msg", str("Chunk data contains ", chunk_data.size(), " blocks"), Debug.DEBUG, self);
	return chunk_data;