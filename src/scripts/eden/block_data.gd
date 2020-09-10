#warning-ignore:unused_class_variable
const meta := {
	script_name = "eden.block_data",
	description = """
		
	"""
}

#static func blocks_old():
#	var mats := Dictionary()
#	# tex order = right, front, back, left, top, bottom
#	generate_block_mesh(mats, 1, "bedrock", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 2, "stone", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 3, "dirt", single_sided_block("dirt"))
#	generate_block_mesh(mats, 4, "sand", single_sided_block("sand"))
#	generate_block_mesh(mats, 5, "leaves", single_sided_block("leaves_green"))
#	generate_block_mesh(mats, 6, "trunk", two_sided_block("tree_side", "tree_top"))
#	generate_block_mesh(mats, 7, "wood", single_sided_block("wood"))
#	generate_block_mesh(mats, 8, "grass", [ "grass_top", "grass_side", "grass_side", "grass_side", "grass_top", "dirt" ])
#	generate_block_mesh(mats, 9, "tnt", two_sided_block("tnt_side", "tnt_top"))
#	generate_block_mesh(mats, 10, "rock", single_sided_block("dark_stone"))
#
#	generate_block_mesh(mats, 11, "weeds", [ "grass_side", "grass_side", "grass_side", "grass_side", "grass_top", "dirt" ])
#	generate_block_mesh(mats, 12, "flowers", [ "grass_side", "grass_side", "grass_side", "grass_side", "grass_top", "dirt" ])
#	generate_block_mesh(mats, 13, "brick", single_sided_block("brick"))
#	generate_block_mesh(mats, 14, "slate", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 15, "ice", single_sided_block("ice"))
#	generate_block_mesh(mats, 16, "wallpaper", single_sided_block("crystal_white"))
#	generate_block_mesh(mats, 17, "trampoline", single_sided_block("trampoline"))
#	generate_block_mesh(mats, 18, "ladder", two_sided_block("ladder_side", "wood"))
#	generate_block_mesh(mats, 19, "cloud", single_sided_block("cloud"))
#	generate_block_mesh(mats, 20, "water", single_sided_block("water"))
#
#	generate_block_mesh(mats, 21, "fence", single_sided_block("weave"))
#	generate_block_mesh(mats, 22, "ivy", single_sided_block("vine"))
#	generate_block_mesh(mats, 23, "lava", single_sided_block("lava"))
#
#	# Triangles
#
#	generate_block_mesh(mats, 24, "rock .S", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 25, "rock .W", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 26, "rock .N", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 27, "rock .E", single_sided_block("grey_stone"))
#
#	generate_block_mesh(mats, 28, "wood .S", single_sided_block("wood"))
#	generate_block_mesh(mats, 29, "wood .W", single_sided_block("wood"))
#	generate_block_mesh(mats, 30, "wood .N", single_sided_block("wood"))
#	generate_block_mesh(mats, 31, "wood .E", single_sided_block("wood"))
#
#	generate_block_mesh(mats, 32, "shing .S", single_sided_block("shingle"))
#	generate_block_mesh(mats, 33, "shing .W", single_sided_block("shingle"))
#	generate_block_mesh(mats, 34, "shing .N", single_sided_block("shingle"))
#	generate_block_mesh(mats, 35, "shing .E", single_sided_block("shingle"))
#
#	generate_block_mesh(mats, 36, "ice .S", single_sided_block("ice"))
#	generate_block_mesh(mats, 37, "ice .W", single_sided_block("ice"))
#	generate_block_mesh(mats, 38, "ice .N", single_sided_block("ice"))
#	generate_block_mesh(mats, 39, "ice .E", single_sided_block("ice"))
#
#	generate_block_mesh(mats, 40, "rock SE", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 41, "rock SW", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 42, "rock NW", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 43, "rock NE", single_sided_block("grey_stone"))
#
#	generate_block_mesh(mats, 44, "wood SE", single_sided_block("wood"))
#	generate_block_mesh(mats, 45, "wood SW", single_sided_block("wood"))
#	generate_block_mesh(mats, 46, "wood NW", single_sided_block("wood"))
#	generate_block_mesh(mats, 47, "wood NE", single_sided_block("wood"))
#
#	generate_block_mesh(mats, 48, "shing SE", single_sided_block("shingle"))
#	generate_block_mesh(mats, 49, "shing SW", single_sided_block("shingle"))
#	generate_block_mesh(mats, 50, "shing NW", single_sided_block("shingle"))
#	generate_block_mesh(mats, 51, "shing NE", single_sided_block("shingle"))
#
#	generate_block_mesh(mats, 52, "ice SE", single_sided_block("ice"))
#	generate_block_mesh(mats, 53, "ice SW", single_sided_block("ice"))
#	generate_block_mesh(mats, 54, "ice NW", single_sided_block("ice"))
#	generate_block_mesh(mats, 55, "ice NE", single_sided_block("ice"))
#
#	# =====
#
#	generate_block_mesh(mats, 56, "shingles", single_sided_block("shingle"))
#	generate_block_mesh(mats, 57, "tile", single_sided_block("gradient"))
#	generate_block_mesh(mats, 58, "glass", single_sided_block("glass"))
#
#	# Liquid
#
#	generate_block_mesh(mats, 59, "water 3/4", single_sided_block("water"))
#	generate_block_mesh(mats, 60, "water 1/2", single_sided_block("water"))
#	generate_block_mesh(mats, 61, "water 1/4", single_sided_block("water"))
#
#	generate_block_mesh(mats, 62, "lava 3/4", single_sided_block("lava"))
#	generate_block_mesh(mats, 63, "lava 1/2", single_sided_block("lava"))
#	generate_block_mesh(mats, 64, "lava 1/4", single_sided_block("lava"))
#
#	# ======
#
#	generate_block_mesh(mats, 65, "fireworks", two_sided_block("fireworks_side", "tnt_top"))
#	generate_block_mesh(mats, 66, "door N", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 67, "door E", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 68, "door S", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 69, "door W", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 70, "door top", single_sided_block("bedrock"))
#
#	generate_block_mesh(mats, 71, "transcube", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 72, "light", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 73, "newflower", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 74, "steel", single_sided_block("bedrock"))
#
#	generate_block_mesh(mats, 75, "pN portal N", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 76, "pE portal E", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 77, "pS portal S", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 78, "pW portal W", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 79, "pT portal top", single_sided_block("bedrock"))
#
#	return mats

static func blocks():
	var mats := Dictionary()
	# tex order = right, front, back, left, top, bottom
	generate_block_mesh(mats, 1, "bedrock", Color(0, 0, 0))
	generate_block_mesh(mats, 2, "stone", Color(0.5, 0.5, 0.5))
	generate_block_mesh(mats, 3, "dirt", Color(0.5, 0.5, 0))
	generate_block_mesh(mats, 4, "sand", Color(0.5, 0.3, 0))
	generate_block_mesh(mats, 5, "leaves", Color(0, 0.8, 0))
	generate_block_mesh(mats, 6, "trunk", Color(0.5, 0.5, 0))
	generate_block_mesh(mats, 7, "wood", Color(0.5, 0.5, 0))
	generate_block_mesh(mats, 8, "grass", Color(0, 0.8, 0))
	generate_block_mesh(mats, 9, "tnt", Color(1, 0, 0))
	generate_block_mesh(mats, 10, "rock", Color(0.2, 0.2, 0.2))
	
	generate_block_mesh(mats, 11, "weeds", Color(0, 0.8, 0))
	generate_block_mesh(mats, 12, "flowers", Color(0.8, 0.3, 0.3))
	generate_block_mesh(mats, 13, "brick", Color(1, 0.1, 0.1))
	generate_block_mesh(mats, 14, "slate", Color(0.1, 0.1, 0.6))
	generate_block_mesh(mats, 15, "ice", Color(0, 0, 1))
	generate_block_mesh(mats, 16, "wallpaper", Color(0.3, 0, 0.3))
	generate_block_mesh(mats, 17, "trampoline", Color(0, 0, 0))
	generate_block_mesh(mats, 18, "ladder", Color(0.5, 0.5, 0.1))
	generate_block_mesh(mats, 19, "cloud", Color(1, 1, 1))
	generate_block_mesh(mats, 20, "water", Color(0, 0, 0.5))
	
	generate_block_mesh(mats, 21, "fence", Color(0.5, 0.5, 0))
	generate_block_mesh(mats, 22, "ivy", Color(0, 0.5, 0.2))
	generate_block_mesh(mats, 23, "lava", Color(1, 0, 0))
	
	# Triangles
	
#	generate_block_mesh(mats, 24, "rock .S", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 25, "rock .W", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 26, "rock .N", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 27, "rock .E", single_sided_block("grey_stone"))
#
#	generate_block_mesh(mats, 28, "wood .S", single_sided_block("wood"))
#	generate_block_mesh(mats, 29, "wood .W", single_sided_block("wood"))
#	generate_block_mesh(mats, 30, "wood .N", single_sided_block("wood"))
#	generate_block_mesh(mats, 31, "wood .E", single_sided_block("wood"))
#
#	generate_block_mesh(mats, 32, "shing .S", single_sided_block("shingle"))
#	generate_block_mesh(mats, 33, "shing .W", single_sided_block("shingle"))
#	generate_block_mesh(mats, 34, "shing .N", single_sided_block("shingle"))
#	generate_block_mesh(mats, 35, "shing .E", single_sided_block("shingle"))
#
#	generate_block_mesh(mats, 36, "ice .S", single_sided_block("ice"))
#	generate_block_mesh(mats, 37, "ice .W", single_sided_block("ice"))
#	generate_block_mesh(mats, 38, "ice .N", single_sided_block("ice"))
#	generate_block_mesh(mats, 39, "ice .E", single_sided_block("ice"))
#
#	generate_block_mesh(mats, 40, "rock SE", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 41, "rock SW", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 42, "rock NW", single_sided_block("grey_stone"))
#	generate_block_mesh(mats, 43, "rock NE", single_sided_block("grey_stone"))
#
#	generate_block_mesh(mats, 44, "wood SE", single_sided_block("wood"))
#	generate_block_mesh(mats, 45, "wood SW", single_sided_block("wood"))
#	generate_block_mesh(mats, 46, "wood NW", single_sided_block("wood"))
#	generate_block_mesh(mats, 47, "wood NE", single_sided_block("wood"))
#
#	generate_block_mesh(mats, 48, "shing SE", single_sided_block("shingle"))
#	generate_block_mesh(mats, 49, "shing SW", single_sided_block("shingle"))
#	generate_block_mesh(mats, 50, "shing NW", single_sided_block("shingle"))
#	generate_block_mesh(mats, 51, "shing NE", single_sided_block("shingle"))
#
#	generate_block_mesh(mats, 52, "ice SE", single_sided_block("ice"))
#	generate_block_mesh(mats, 53, "ice SW", single_sided_block("ice"))
#	generate_block_mesh(mats, 54, "ice NW", single_sided_block("ice"))
#	generate_block_mesh(mats, 55, "ice NE", single_sided_block("ice"))
#
#	# =====
#
#	generate_block_mesh(mats, 56, "shingles", single_sided_block("shingle"))
#	generate_block_mesh(mats, 57, "tile", single_sided_block("gradient"))
#	generate_block_mesh(mats, 58, "glass", single_sided_block("glass"))
#
#	# Liquid
#
#	generate_block_mesh(mats, 59, "water 3/4", single_sided_block("water"))
#	generate_block_mesh(mats, 60, "water 1/2", single_sided_block("water"))
#	generate_block_mesh(mats, 61, "water 1/4", single_sided_block("water"))
#
#	generate_block_mesh(mats, 62, "lava 3/4", single_sided_block("lava"))
#	generate_block_mesh(mats, 63, "lava 1/2", single_sided_block("lava"))
#	generate_block_mesh(mats, 64, "lava 1/4", single_sided_block("lava"))
#
#	# ======
#
#	generate_block_mesh(mats, 65, "fireworks", two_sided_block("fireworks_side", "tnt_top"))
#	generate_block_mesh(mats, 66, "door N", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 67, "door E", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 68, "door S", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 69, "door W", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 70, "door top", single_sided_block("bedrock"))
#
#	generate_block_mesh(mats, 71, "transcube", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 72, "light", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 73, "newflower", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 74, "steel", single_sided_block("bedrock"))
#
#	generate_block_mesh(mats, 75, "pN portal N", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 76, "pE portal E", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 77, "pS portal S", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 78, "pW portal W", single_sided_block("bedrock"))
#	generate_block_mesh(mats, 79, "pT portal top", single_sided_block("bedrock"))
	
	return mats

static func generate_block_mesh(mats: Dictionary, id: int, _block_name: String, color: Color): ###########################
	var mat = SpatialMaterial.new()
	#var tex = load("res://aux/assets/textures/" + textures[0] + ".png")
	mat.albedo_color = color
	
	mats[id] = mat


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
