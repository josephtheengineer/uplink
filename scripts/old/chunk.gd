extends MeshInstance

############################## public variables ###############################

#onready var blocks = preload("res://block.meshlib").duplicate()
var World
var Hud


var block_data = Dictionary()
var mesh_data = Array()
var block_materials = Dictionary()
var blocks_loaded = 0

var chunk_location = Vector3(0, 0, 0)
var chunk_address = 0




################################### signals ###################################

func _ready(): ################################################################
	if chunk_location.y != 0:
		return
	Hud = World.Hud
	
	place_block(0, Vector3(0, 0, 0))
	
	# tex order = right, front, back, left, top, bottom
	generate_block_mesh(1, "bedrock", single_sided_block("bedrock"))
	generate_block_mesh(2, "stone", single_sided_block("grey_stone"))
	generate_block_mesh(3, "dirt", single_sided_block("dirt"))
	generate_block_mesh(4, "sand", single_sided_block("sand"))
	generate_block_mesh(5, "leaves", single_sided_block("leaves_green"))
	generate_block_mesh(6, "trunk", two_sided_block("tree_side", "tree_top"))
	generate_block_mesh(7, "wood", single_sided_block("wood"))
	generate_block_mesh(8, "grass", [ "grass_top", "grass_side", "grass_side", "grass_side", "grass_top", "dirt" ])
	generate_block_mesh(9, "tnt", two_sided_block("tnt_side", "tnt_top"))
	generate_block_mesh(10, "rock", single_sided_block("dark_stone"))
	
	generate_block_mesh(11, "weeds", [ "grass_side", "grass_side", "grass_side", "grass_side", "grass_top", "dirt" ])
	generate_block_mesh(12, "flowers", [ "grass_side", "grass_side", "grass_side", "grass_side", "grass_top", "dirt" ])
	generate_block_mesh(13, "brick", single_sided_block("brick"))
	generate_block_mesh(14, "slate", single_sided_block("bedrock"))
	generate_block_mesh(15, "ice", single_sided_block("ice"))
	generate_block_mesh(16, "wallpaper", single_sided_block("crystal_white"))
	generate_block_mesh(17, "trampoline", single_sided_block("trampoline"))
	generate_block_mesh(18, "ladder", two_sided_block("ladder_side", "wood"))
	generate_block_mesh(19, "cloud", single_sided_block("cloud"))
	generate_block_mesh(20, "water", single_sided_block("water"))
	
	generate_block_mesh(21, "fence", single_sided_block("weave"))
	generate_block_mesh(22, "ivy", single_sided_block("vine"))
	generate_block_mesh(23, "lava", single_sided_block("lava"))
	
	# Triangles
	
	generate_block_mesh(24, "rock .S", single_sided_block("grey_stone"))
	generate_block_mesh(25, "rock .W", single_sided_block("grey_stone"))
	generate_block_mesh(26, "rock .N", single_sided_block("grey_stone"))
	generate_block_mesh(27, "rock .E", single_sided_block("grey_stone"))
	
	generate_block_mesh(28, "wood .S", single_sided_block("wood"))
	generate_block_mesh(29, "wood .W", single_sided_block("wood"))
	generate_block_mesh(30, "wood .N", single_sided_block("wood"))
	generate_block_mesh(31, "wood .E", single_sided_block("wood"))
	
	generate_block_mesh(32, "shing .S", single_sided_block("shingle"))
	generate_block_mesh(33, "shing .W", single_sided_block("shingle"))
	generate_block_mesh(34, "shing .N", single_sided_block("shingle"))
	generate_block_mesh(35, "shing .E", single_sided_block("shingle"))
	
	generate_block_mesh(36, "ice .S", single_sided_block("ice"))
	generate_block_mesh(37, "ice .W", single_sided_block("ice"))
	generate_block_mesh(38, "ice .N", single_sided_block("ice"))
	generate_block_mesh(39, "ice .E", single_sided_block("ice"))
	
	generate_block_mesh(40, "rock SE", single_sided_block("grey_stone"))
	generate_block_mesh(41, "rock SW", single_sided_block("grey_stone"))
	generate_block_mesh(42, "rock NW", single_sided_block("grey_stone"))
	generate_block_mesh(43, "rock NE", single_sided_block("grey_stone"))
	
	generate_block_mesh(44, "wood SE", single_sided_block("wood"))
	generate_block_mesh(45, "wood SW", single_sided_block("wood"))
	generate_block_mesh(46, "wood NW", single_sided_block("wood"))
	generate_block_mesh(47, "wood NE", single_sided_block("wood"))
	
	generate_block_mesh(48, "shing SE", single_sided_block("shingle"))
	generate_block_mesh(49, "shing SW", single_sided_block("shingle"))
	generate_block_mesh(50, "shing NW", single_sided_block("shingle"))
	generate_block_mesh(51, "shing NE", single_sided_block("shingle"))
	
	generate_block_mesh(52, "ice SE", single_sided_block("ice"))
	generate_block_mesh(53, "ice SW", single_sided_block("ice"))
	generate_block_mesh(54, "ice NW", single_sided_block("ice"))
	generate_block_mesh(55, "ice NE", single_sided_block("ice"))
	
	# =====
	
	generate_block_mesh(56, "shingles", single_sided_block("shingle"))
	generate_block_mesh(57, "tile", single_sided_block("gradient"))
	generate_block_mesh(58, "glass", single_sided_block("glass"))
	
	# Liquid
	
	generate_block_mesh(59, "water 3/4", single_sided_block("water"))
	generate_block_mesh(60, "water 1/2", single_sided_block("water"))
	generate_block_mesh(61, "water 1/4", single_sided_block("water"))
	
	generate_block_mesh(62, "lava 3/4", single_sided_block("lava"))
	generate_block_mesh(63, "lava 1/2", single_sided_block("lava"))
	generate_block_mesh(64, "lava 1/4", single_sided_block("lava"))
	
	# ======
	
	generate_block_mesh(65, "fireworks", two_sided_block("fireworks_side", "tnt_top"))
	generate_block_mesh(66, "door N", single_sided_block("bedrock"))
	generate_block_mesh(67, "door E", single_sided_block("bedrock"))
	generate_block_mesh(68, "door S", single_sided_block("bedrock"))
	generate_block_mesh(69, "door W", single_sided_block("bedrock"))
	generate_block_mesh(70, "door top", single_sided_block("bedrock"))
	
	generate_block_mesh(71, "transcube", single_sided_block("bedrock"))
	generate_block_mesh(72, "light", single_sided_block("bedrock"))
	generate_block_mesh(73, "newflower", single_sided_block("bedrock"))
	generate_block_mesh(74, "steel", single_sided_block("bedrock"))
	
	generate_block_mesh(75, "pN portal N", single_sided_block("bedrock"))
	generate_block_mesh(76, "pE portal E", single_sided_block("bedrock"))
	generate_block_mesh(77, "pS portal S", single_sided_block("bedrock"))
	generate_block_mesh(78, "pW portal W", single_sided_block("bedrock"))
	generate_block_mesh(79, "pT portal top", single_sided_block("bedrock"))
	
	
	var TerrainGenerator = load("res://scripts/terrain_generator.gd").new()
	TerrainGenerator._ready()
	
	if World.map_seed == -1 and chunk_location == Vector3(0, 0, 0):
		var chunk_data = TerrainGenerator.generate_random_terrain()
		for position in chunk_data.keys():
			place_block(chunk_data[position], position)
		
		compile()
	elif World.map_seed == 0:
		var chunk_data = TerrainGenerator.generate_flat_terrain()
		for position in chunk_data.keys():
			place_block(chunk_data[position], position)
		
		compile()
	else:
		var chunk_data = TerrainGenerator.generate_natural_terrain()
		for position in chunk_data.keys():
			place_block(chunk_data[position], position)
		
		compile()




################################## functions ##################################


func load_terrain(): ##########################################################
	# Get the chunk data from the WORLD FILE.
	#Hud.msg("Running GetChunkData on chunk ", ChunkMetadata[i].Address, "...", Debug.DEBUG, self)
	var EdenWorldDecoder = load("res://scripts/eden_world_decoder.gd").new()
	EdenWorldDecoder.World = World
	EdenWorldDecoder.set_vars()
	var ChunkData = EdenWorldDecoder.get_chunk_data(Vector2(chunk_location.x, chunk_location.z))
	World.loaded = true
	if typeof(ChunkData) == TYPE_BOOL:
		var TerrainGenerator = load("res://scripts/terrain_generator.gd").new()
		TerrainGenerator._ready()
		var chunk_data = TerrainGenerator.generate_flat_terrain()
		for position in chunk_data.keys():
			place_block(chunk_data[position], position)
		
		compile()
		return false
	
	Hud.msg("Creating the chunk mesh... ", Debug.DEBUG, self)
	#CreateChunk(ChunkMetadata[i].Address, x, y, z)
	
	# ==============================================================================
	Hud.msg(["Chunk data contains ", ChunkData.size(), " blocks"], Debug.DEBUG, self)
	Hud.msg("Placing blocks... ", Debug.DEBUG, self)
	# Place all the blocks contained in the chunk data.
	for Blocks in range(ChunkData.size()):
		var position = ChunkData[Blocks].position
		var id = ChunkData[Blocks].id
		
		if position.x < 4:
			place_block(id, position)
	compile()
	#Status+=1
	#LoadedChunks+=1


func generate_block_mesh(id, block_name, textures): ###########################
	var mat = SpatialMaterial.new()
	var tex = load("res://textures/" + textures[0] + ".png")
	mat.albedo_texture = tex
	
	block_materials[id] = mat


func single_sided_block(data): ################################################
	var arr = Array()
	for i in range(6):
		arr.append(data)
	return arr


func two_sided_block(side_tex, top_bot_tex): ##################################
	var arr = Array()
	for i in range(4):
		arr.append(side_tex)
	for i in range(2):
		arr.append(top_bot_tex)
	return arr


func break_block(location): ####################################################
	#Hud.msg("Chunk translation: " + str(translation), Debug.DEBUG, self)
	#Hud.msg("Removing block from chunk location " + str(location - translation), Debug.INFO, self)
	block_data.erase(location - translation)


func place_block(id, location): ################################################
	#Hud.msg("Chunk translation: " + str(translation), Debug.DEBUG, self)
	#Hud.msg("Placing block from chunk location " + str(location - translation), Debug.INFO, self)
	if id != 0:
		block_data[location - translation] = id
	
	#set_surface_material(0, "texture")

func compile():
	Hud.msg("Compiling chunk...", Debug.INFO, self)
	mesh = null
	mesh_data = Array()
	
	#mat.albedo_color = Color(1, 0, 0, 1)
	
	for position in block_data.keys():
		if can_be_seen(position).size() != 6:
			create_cube(position, block_data[position])
			blocks_loaded += 1
	
	#st.generate_normals(false)
	#st.index()
	#mesh = st.commit()
	
	var shape = ConcavePolygonShape.new()
	shape.set_faces(mesh_data)
	
	var collision_shape = get_node("StaticBody/CollisionShape")
	collision_shape.shape = shape

const surrounding_blocks = [ Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0) ]

func can_be_seen(position):
	var num_surrounding_blocks = [ ]
	
	for surrounding_position in surrounding_blocks:
		if block_data.has(position + surrounding_position):
			num_surrounding_blocks.append(surrounding_position)
	return num_surrounding_blocks


func create_cube(position, id):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(block_materials[id])
	
	var sides_not_to_render = can_be_seen(position)
	
	if !sides_not_to_render.has(Vector3(0, -1, 0)):
		create_horizontal_plane(st, position + Vector3(0, -1, 0), "down")
	
	if !sides_not_to_render.has(Vector3(0, 1, 0)): 
		create_horizontal_plane(st, position + Vector3(0, 0, 0), "up")
	
	
	
	if !sides_not_to_render.has(Vector3(0, 0, 1)):
		create_vertical_plane(st, position + Vector3(0, 0, 1), "west")
	
	if !sides_not_to_render.has(Vector3(0, 0, -1)):
		create_vertical_plane(st, position + Vector3(0, 0, 0), "east")
	
	if !sides_not_to_render.has(Vector3(-1, 0, 0)):
		create_vertical_plane(st, position + Vector3(0, 0, 0), "north")
	
	if !sides_not_to_render.has(Vector3(1, 0, 0)):
		create_vertical_plane(st, position + Vector3(1, 0, 0), "south")
	
	mesh = st.commit(mesh)

const vertical_plane_uvs = [ Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), Vector2(1, 1) ]
const vertical_plane_vertices = [ Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(1, -1, 0), Vector3(0, -1, 0), Vector3(1, 0, 0) ]

const vertical_plane_uvs2 = [ Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), Vector2(1, 1) ]
const vertical_plane_vertices2 = [ Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, -1, 1), Vector3(0, -1, 0), Vector3(0, 0, 1) ]

func create_vertical_plane(st, position, direction):
	if direction == "west":
		for i in range(vertical_plane_vertices.size()):
			st.add_uv(vertical_plane_uvs[i])
			st.add_vertex(vertical_plane_vertices[i] + position)
			mesh_data.append(vertical_plane_vertices[i] + position)
		
	elif direction == "east":
		vertical_plane_vertices.invert()
		vertical_plane_uvs.invert()
		for i in range(vertical_plane_vertices.size()):
			st.add_uv(vertical_plane_uvs[i])
			st.add_vertex(vertical_plane_vertices[i] + position)
			mesh_data.append(vertical_plane_vertices[i] + position)
		
		vertical_plane_vertices.invert()
		vertical_plane_uvs.invert()
	
	
	
	elif direction == "north":
		for i in range(vertical_plane_vertices2.size()):
			st.add_uv(vertical_plane_uvs2[i])
			st.add_vertex(vertical_plane_vertices2[i] + position)
			mesh_data.append(vertical_plane_vertices2[i] + position)
	
	elif direction == "south":
		vertical_plane_vertices2.invert()
		vertical_plane_uvs2.invert()
		for i in range(vertical_plane_vertices2.size()):
			st.add_uv(vertical_plane_uvs2[i])
			st.add_vertex(vertical_plane_vertices2[i] + position)
			mesh_data.append(vertical_plane_vertices2[i] + position)
		
		vertical_plane_vertices2.invert()
		vertical_plane_uvs2.invert()

const horizontal_plane_uvs = [ Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(0, 1), Vector2(1, 0) ]
const horizontal_plane_vertices = [ Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(0, 0, 1), Vector3(1, 0, 0) ]

func create_horizontal_plane(st, position, direction):
	if direction == "up":
		for i in range(horizontal_plane_vertices.size()):
			st.add_uv(horizontal_plane_uvs[i])
			st.add_vertex(horizontal_plane_vertices[i] + position)
			mesh_data.append(horizontal_plane_vertices[i] + position)
		
	elif direction == "down":
		horizontal_plane_vertices.invert()
		horizontal_plane_uvs.invert()
		for i in range(horizontal_plane_vertices.size()):
			st.add_uv(horizontal_plane_uvs[i])
			st.add_vertex(horizontal_plane_vertices[i] + position)
			mesh_data.append(horizontal_plane_vertices[i] + position)
		
		horizontal_plane_vertices.invert()
		horizontal_plane_uvs.invert()



