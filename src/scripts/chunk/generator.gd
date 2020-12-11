#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.generator",
	description = """
		
	"""
}

static func generate_noise(): ##################################################
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	
	noise.octaves = 4
	noise.period = 15
	noise.lacunarity = 1.5
	noise.persistence = 0.75
	return noise

static func generate_random_terrain(): #########################################
	var chunk_data = Dictionary()
	for x in 5:
		for y in 10:
			for z in 10:
				if floor(rand_range(0, 3)) == 1:
					chunk_data[Vector3(x, y, z)] = int(
							floor(rand_range(1, 80))
						)
	return chunk_data


static func generate_flat_terrain(): ###########################################
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
	return chunk_data


static func generate_box():
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
	return voxel_data


static func generate_block():
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
	return voxel_data


static func generate_small_box():
	var voxel_data = Dictionary()
	
	voxel_data[Vector3(16/2, 16/2, 16/2)] = 1
	return voxel_data


static func single_voxel(): ####################################################
	var chunk_data = Dictionary()
	chunk_data[Vector3(8, 8, 8)] = {}
	chunk_data[Vector3(8, 8, 8)].id = 8
	chunk_data[Vector3(8, 8, 8)].voxels = generate_box()
	return chunk_data

static func plane(): ###########################################################
	var chunk_data = Dictionary()
	for x in 16:
		for y in 16:
			for z in 16:
				if x == 0:
					chunk_data[Vector3(x, y, z)] = 1
				elif z == 0:
					chunk_data[Vector3(x, y, z)] = 1
				elif y == 0:
					chunk_data[Vector3(x, y, z)] = 1
				elif x == 15:
					chunk_data[Vector3(x, y, z)] = 1
				elif y == 15:
					chunk_data[Vector3(x, y, z)] = 1
	return chunk_data


static func generate_natural_terrain(noise): ###################################
	var chunk_data = Dictionary()
	var id = 0
	var color = 0
	for x in 16:
		for y in 16:
			for z in 16:
				var value = noise.get_noise_3d(float(x), 
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
				
					chunk_data[Vector3(
							x, y, z
						)] = block_data;
	return chunk_data


static func generate_matrix_terrain(): #########################################
	for x in range(16):
		for y in range(16):
			for z in range(16):
				if x == 0 and y == 0 and z == 0:
					pass
					#if y >= 15:
						#place_block(8, Vector3(
						#	x, y, z)
						#)
					#elif y > 10:
						#place_block(3, Vector3(
						#	x, y, z)
						#)
					#else:
						#place_block(2, Vector3(
						#	x, y, z)
						#)


static func generate_simple_terrain(): #########################################
	for x in range(16):
		for y in range(16):
			for z in range(16):
				#if x == 15 or x == 0 or z == 15
							 # or z == 0 or y == 15:
				if y == 0 && x != 15 && z != 15:
					pass
					#place_block(2, Vector3(x, y, z))
				elif y == 0:
					pass
					#place_block(4, Vector3(x, y, z))
						#place_block(8, x, y, z)
					#elif y > 10:
						#place_block(3, x, y, z)
					#else:
						#place_block(x, y, z, 2)
	#place_block(2, 0, 0, 0)
	#compile()

#static func text(string):
#	pass
