#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.generator",
	description = """
		
	"""
}

# chunk.generator.noise ########################################################
const noise_meta := {
	func_name = "chunk.generator.noise",
	description = """
		noise generator helper function
	""",
		noise = null}
static func noise(args := noise_meta) -> void: #################################
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	
	noise.octaves = 4
	noise.period = 15
	noise.lacunarity = 1.5
	noise.persistence = 0.75
	args.noise = noise
# ^ chunk.generator.noise ######################################################


# chunk.generator.random_terrain ###############################################
const random_terrain_meta := {
	func_name = "chunk.generator.random_terrain",
	description = """
		___#_____##______#___
		#     #      #       |
		#  ##      #    #  # |
		|     #  #  ##   # # |
		#     ##  #     ##   |
		|   #   #     ##     #
		##  #  #  #      #   |
		|___#_#___##_________|
	""",
		data = Dictionary()}
static func random_terrain(args := random_terrain_meta) -> void: ###############
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				if floor(rand_range(0, 3)) == 1:
					args.data[Vector3(x, y, z)] = int(
							floor(rand_range(1, 80))
						)
# ^ chunk.generator.random_terrain #############################################


# chunk.generator.flat_terrain #################################################
const flat_terrain_meta := {
	func_name = "chunk.generator.flat_terrain",
	description = """
		_____________________
		|                    |
		|                    |
		|                    |
		|                    |
		######################
		######################
		######################
	""",
		data = Dictionary()}
static func flat_terrain(args := flat_terrain_meta) -> void: ###################
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				if y == 0 and x == 0:
					args.data[Vector3(x, y, z)] = 8
				#elif y == 15:
					#chunk_data[Vector3(x, y, z)] = 8
				#elif y > 1:
					#chunk_data[Vector3(x, y, z)] = 3
				#else:
					#chunk_data[Vector3(x, y, z)] = 2
# ^ chunk.generator.flat_terrain ###############################################


# chunk.generator.generate_box #################################################
const generate_box_meta := {
	func_name = "chunk.generator.generate_box",
	description = """
		######################
		#                    #
		#                    #
		#                    #
		#                    #
		#                    #
		#                    #
		######################
	""",
		data = Dictionary()}
static func generate_box(args := generate_box_meta) -> void: ###################
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				if x == 0:
					args.data[Vector3(x, y, z)] = 1
				elif z == 0:
					args.data[Vector3(x, y, z)] = 1
				elif y == 0:
					args.data[Vector3(x, y, z)] = 1
				elif x == 7:
					args.data[Vector3(x, y, z)] = 1
				elif y == 7:
					args.data[Vector3(x, y, z)] = 1
# ^ chunk.generator.generate_box ###############################################


# chunk.generator.block ########################################################
const block_meta := {
	func_name = "chunk.generator.block",
	description = """
		######################
		######################
		######################
		######################
		######################
		######################
		######################
		######################
	""",
		data = Dictionary()}
static func block(args := block_meta) -> void: #################################
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				args.data[Vector3(x, y, z)] = 1
# ^ chunk.generator.block ######################################################


# chunk.generator.single_voxel #################################################
const single_voxel_meta := {
	func_name = "chunk.generator.single_voxel",
	description = """
		_____________________
		|                    |
		|                    |
		|                    |
		|         #          |
		|                    |
		|                    |
		|____________________|
	""",
		data = Dictionary()}
static func single_voxel(args := single_voxel_meta) -> void: ###################
	args.data[Vector3(0, 0, 0)] = 1
# ^ chunk.generator.single_voxel ###############################################


# chunk.generator.plane ########################################################
const plane_meta := {
	func_name = "chunk.generator.plane",
	description = """
		
	""",
		data = Dictionary()}
static func plane(args := plane_meta) -> void: #################################
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				if x == 0:
					args.data[Vector3(x, y, z)] = 1
				elif z == 0:
					args.data[Vector3(x, y, z)] = 1
				elif y == 0:
					args.data[Vector3(x, y, z)] = 1
				elif x == 7:
					args.data[Vector3(x, y, z)] = 1
				elif y == 7:
					args.data[Vector3(x, y, z)] = 1
# ^ chunk.generator.plane ######################################################


# chunk.generator.generate_natural_terrain #####################################
const generate_natural_terrain_meta := {
	func_name = "chunk.generator.generate_natural_terrain",
	description = """
		
	""",
		noise = null,
		data = Dictionary()}
static func generate_natural_terrain(args := generate_natural_terrain_meta) -> void: 
	var id = 0
	var color = 0
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				var value = args.noise.get_noise_3d(float(x), 
							     float(y), float(z))
				if value > 0:
					if y == 0:
						id = 1
					elif y == 15:
						id = 8
					elif y > 10:
						id = 3
					else:
						id = 2
					#chunk_data[Vector3(x, y, z)] = int(
						       #floor(rand_range(1, 4)))
					
					var block_data  = {
						"id": id, 
						"color": color
					}
				
					args.data[Vector3(
							x, y, z
						)] = block_data;
# ^ chunk.generator.generate_natural_terrain ###################################


# chunk.generator.generate_matrix_terrain ######################################
const generate_matrix_terrain_meta := {
	func_name = "chunk.generator.generate_matrix_terrain",
	description = """
		
	""",
		data = Dictionary()}
static func generate_matrix_terrain(args := generate_matrix_terrain_meta) -> void: 
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				if x == 0 and y == 0 and z == 0:
					if y >= 7:
						args.data[Vector3(x, y, z)] = 8
					elif y > 10:
						args.data[Vector3(x, y, z)] = 3
					else:
						args.data[Vector3(x, y, z)] = 2
# ^ chunk.generator.generate_matrix_terrain ####################################


# chunk.generator.generate_simple_terrain ######################################
const generate_simple_terrain_meta := {
	func_name = "chunk.generator.generate_simple_terrain",
	description = """
		
	""",
		data = Dictionary()}
static func generate_simple_terrain(args := generate_simple_terrain_meta) -> void: 
	for x in range(-7, 8):
		for y in range(-7, 8):
			for z in range(-7, 8):
				#if x == 15 or x == 0 or z == 15
							 # or z == 0 or y == 15:
				if y == 0 && x != 15 && z != 15:
					args.data[Vector3(x, y, z)] = 2
				elif y == 0:
					args.data[Vector3(x, y, z)] = 4
				elif y > 10:
					args.data[Vector3(x, y, z)] = 3
				else:
					args.data[Vector3(x, y, z)] = 2
# ^ chunk.generator.generate_simple_terrain ####################################
