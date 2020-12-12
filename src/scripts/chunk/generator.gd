#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.generator",
	description = """
		
	"""
}

# chunk.generator.generate_noise ###############################################
const generate_noise_meta := {
	func_name = "chunk.generator.generate_noise",
	description = """
		
	""",
		noise = null}
static func generate_noise(args := generate_noise_meta) -> void: ###############
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	
	noise.octaves = 4
	noise.period = 15
	noise.lacunarity = 1.5
	noise.persistence = 0.75
	args.noise = noise
# ^ chunk.generator.generate_noise #############################################


# chunk.generator.generate_random_terrain ######################################
const generate_random_terrain_meta := {
	func_name = "chunk.generator.generate_noise",
	description = """
		
	""",
		data = Dictionary()}
static func generate_random_terrain(args := generate_random_terrain_meta) -> void: 
	var chunk_data = Dictionary()
	for x in 5:
		for y in 10:
			for z in 10:
				if floor(rand_range(0, 3)) == 1:
					chunk_data[Vector3(x, y, z)] = int(
							floor(rand_range(1, 80))
						)
	args.data = chunk_data
# ^ chunk.generator.generate_random_terrain ####################################


# chunk.generator.generate_flat_terrain ########################################
const generate_flat_terrain_meta := {
	func_name = "chunk.generator.generate_flat_terrain",
	description = """
		
	""",
		data = Dictionary()}
static func generate_flat_terrain(args := generate_flat_terrain_meta) -> void: #
	var chunk_data = Dictionary()
	for x in 16:
		for y in 16:
			for z in 16:
				if y == 0 and x == 0:
					chunk_data[Vector3(x, y, z)] = {}
					chunk_data[Vector3(x, y, z)].id = 8
				#elif y == 15:
					#chunk_data[Vector3(x, y, z)] = 8
				#elif y > 1:
					#chunk_data[Vector3(x, y, z)] = 3
				#else:
					#chunk_data[Vector3(x, y, z)] = 2
	args.data = chunk_data
# ^ chunk.generator.generate_flat_terrain ######################################


# chunk.generator.generate_box #################################################
const generate_box_meta := {
	func_name = "chunk.generator.generate_box",
	description = """
		
	""",
		data = Dictionary()}
static func generate_box(args := generate_box_meta) -> void: ###################
	var voxel_data = Dictionary()
	# draw an outline of voxels (for debuging mostly)
#	for x in 16:
#		for y in 16:
#			for z in 16:
#				if x == 0 and y == 0 or x == 0 and z == 0 or z == 0 and y == 0:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 15 and y == 15 or x == 15 and z == 15 or z == 15 and y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 15 and y == 0 or x == 15 and z == 0 or z == 15 and y == 0:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 0 and y == 15 or x == 0 and z == 15 or z == 0 and y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
	for x in 16:
		for y in 16:
			for z in 16:
				if x == 0:
					voxel_data[Vector3(x, y, z)] = 1
				elif z == 0:
					voxel_data[Vector3(x, y, z)] = 1
				elif y == 0:
					voxel_data[Vector3(x, y, z)] = 1
				elif x == 15:
					voxel_data[Vector3(x, y, z)] = 1
				elif y == 15:
					voxel_data[Vector3(x, y, z)] = 1
	args.data = voxel_data
# ^ chunk.generator.generate_box ###############################################


# chunk.generator.generate_block ###############################################
const generate_block_meta := {
	func_name = "chunk.generator.generate_block",
	description = """
		
	""",
		data = Dictionary()}
static func generate_block(args := generate_block_meta) -> void: ###############
	var voxel_data = Dictionary()
	# draw an outline of voxels (for debuging mostly)
#	for x in 16:
#		for y in 16:
#			for z in 16:
#				if x == 0 and y == 0 or x == 0 and z == 0 or z == 0 and y == 0:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 15 and y == 15 or x == 15 and z == 15 or z == 15 and y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 15 and y == 0 or x == 15 and z == 0 or z == 15 and y == 0:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif x == 0 and y == 15 or x == 0 and z == 15 or z == 0 and y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
#				elif y == 15:
#					voxel_data[Vector3(x*VSIZE, y*VSIZE, z*VSIZE)] = 1
	for x in 16:
		for y in 16:
			for z in 16:
				voxel_data[Vector3(x, y, z)] = 1
	args.data = voxel_data
# ^ chunk.generator.generate_block #############################################


# chunk.generator.generate_small_box ###########################################
const generate_small_box_meta := {
	func_name = "chunk.generator.generate_small_box",
	description = """
		
	""",
		data = Dictionary()}
static func generate_small_box(args := generate_small_box_meta) -> void: #######
	args.data[Vector3(16/2, 16/2, 16/2)] = 1
# ^ chunk.generator.generate_small_box #########################################


# chunk.generator.single_voxel #################################################
const single_voxel_meta := {
	func_name = "chunk.generator.single_voxel",
	description = """
		
	""",
		data = Dictionary()}
static func single_voxel(args := single_voxel_meta) -> void: ###################
	args.data[Vector3(8, 8, 8)] = {}
	args.data[Vector3(8, 8, 8)].id = 8
	args.data[Vector3(8, 8, 8)].voxels = generate_box()
# ^ chunk.generator.single_voxel ###############################################


# chunk.generator.plane ########################################################
const plane_meta := {
	func_name = "chunk.generator.plane",
	description = """
		
	""",
		data = Dictionary()}
static func plane(args := plane_meta) -> void: #################################
	for x in 16:
		for y in 16:
			for z in 16:
				if x == 0:
					args.data[Vector3(x, y, z)] = 1
				elif z == 0:
					args.data[Vector3(x, y, z)] = 1
				elif y == 0:
					args.data[Vector3(x, y, z)] = 1
				elif x == 15:
					args.data[Vector3(x, y, z)] = 1
				elif y == 15:
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
	for x in 16:
		for y in 16:
			for z in 16:
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
	for x in range(16):
		for y in range(16):
			for z in range(16):
				if x == 0 and y == 0 and z == 0:
					if y >= 15:
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
	for x in range(16):
		for y in range(16):
			for z in range(16):
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
