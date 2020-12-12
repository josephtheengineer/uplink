#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.eden.block_data",
	description = """
		
	"""
}

const name := [
	"bedrock",
	"stone",
	"dirt",
	"sand",
	"leaves",
	"wood",
	"planks",
	"grass",
	"tnt",
	"rock",
	"weeds",
	"flowers",
	"brick",
	"slate",
	"ice",
	"wallpaper",
	"trampoline",
	"ladder",
	"cloud",
	"water",
	"fence",
	"ivy",
	"lava",
	
	"rock .S",
	"rock .W",
	"rock .N",
	"rock .E",
	
	"wood .S",
	"wood .W",
	"wood .N",
	"wood .E",
	
	"shing .S",
	"shing .W",
	"shing .N",
	"shing .E",
	
	"ice .S",
	"ice .W",
	"ice .N",
	"ice .E",
	
	"rock SE",
	"rock SW",
	"rock NW",
	"rock NE",
	
	"wood SE",
	"wood SW",
	"wood NW",
	"wood NE",
	
	"shing SE",
	"shing SW",
	"shing NW",
	"shing NE",
	
	"ice SE",
	"ice SW",
	"ice NW",
	"ice NE",
	
	"shingles",
	"tile",
	"glass",
	
	"water 3/4",
	"water 1/2",
	"water 1/4",
	
	"lava 3/4",
	"lava 1/2",
	"lava 1/4",
	
	"fireworks",
	
	"door N",
	"door E",
	"door S",
	"door W",
	"door top",
	
	"transcube",
	"light",
	"newflower",
	"steel",
	
	"pN portal N",
	"pE portal E",
	"pE portal S",
	"pE portal W",
	"pT portal top"
]

const color := [
	Color(0, 0, 0),
	Color(0.5, 0.5, 0.5),
	Color(0.5, 0.5, 0),
	Color(0.5, 0.3, 0),
	Color(0, 0.8, 0),
	Color(0.5, 0.5, 0),
	Color(0.5, 0.5, 0),
	Color(0, 0.8, 0),
	Color(1, 0, 0),
	Color(0.2, 0.2, 0.2),
	
	Color(0, 0.8, 0),
	Color(0.8, 0.3, 0.3),
	Color(1, 0.1, 0.1),
	Color(0.1, 0.1, 0.6),
	Color(0, 0, 1),
	Color(0.3, 0, 0.3),
	Color(0, 0, 0),
	Color(0.5, 0.5, 0.1),
	Color(1, 1, 1),
	Color(0, 0, 0.5),
	
	Color(0.5, 0.5, 0),
	Color(0, 0.5, 0.2),
	Color(1, 0, 0)
]


# chunk.eden.block_data.generate_block_mat #####################################
const generate_block_mat_meta := {
	func_name = "chunk.eden.block_data.generate_block_mat",
	description = """
		
	""",
		mat = SpatialMaterial,
		id = 0,
		name =  "",
		color = Color()}
static func generate_block_mat(args := generate_block_mat_meta) -> void: #######
	var mat = SpatialMaterial.new()
	#var tex = load("res://aux/assets/textures/" + textures[0] + ".png")
	mat.albedo_color = args.color
	
	args.mat = mat
# ^ chunk.eden.block_data.generate_block_mat ###################################
