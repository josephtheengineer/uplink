#warning-ignore:unused_class_variable
const meta := {
	script_name = "eden.block_data",
	description = """
		
	"""
}

static func blocks():
	var block_materials := Dictionary()
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
	
	return block_materials

static func generate_block_mesh(id: int, _block_name: String, textures: Array): ###########################
	var mat = SpatialMaterial.new()
	var tex = load("res://aux/assets/textures/" + textures[0] + ".png")
	mat.albedo_texture = tex
	
	#block_materials[id] = mat


static func single_sided_block(data): ################################################
	var arr = Array()
	for _i in range(6):
		arr.append(data)
	return arr


static func two_sided_block(side_tex, top_bot_tex): ##################################
	var arr = Array()
	for _i in range(4):
		arr.append(side_tex)
	for _i in range(2):
		arr.append(top_bot_tex)
	return arr
