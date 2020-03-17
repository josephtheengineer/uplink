extends VBoxContainer

const FLAT = 0
const EDEN1 = 1
const EDEN2 = 2

onready var World = get_node("/root/Main Menu/World")
onready var Hud = get_node("/root/Main Menu")

onready var flat_button = get_node(
	"Content/VBoxContainer/Main/Left/TerrainGenMode/HBoxContainer/VBoxContainer/Flat")

onready var eden1_button = get_node(
	"Content/VBoxContainer/Main/Left/TerrainGenMode/HBoxContainer/VBoxContainer2/Eden1")

onready var eden2_button = get_node(
	"Content/VBoxContainer/Main/Left/TerrainGenMode/HBoxContainer/VBoxContainer3/Eden2")

var terrain_mode = FLAT

func _mode_button_pressed(mode):
	match mode:
		FLAT:
			terrain_mode = FLAT
			flat_button.pressed = true
			eden1_button.pressed = false
			eden2_button.pressed = false
		EDEN1:
			terrain_mode = EDEN1
			flat_button.pressed = false
			eden1_button.pressed = true
			eden2_button.pressed = false
		EDEN2:
			terrain_mode = EDEN2
			flat_button.pressed = false
			eden1_button.pressed = false
			eden2_button.pressed = true

func _start_generation():
	match terrain_mode:
		FLAT:
			Hud.msg("Loading a new flat terrain world...", Debug.INFO, self)
			Hud.map_path = ""
			Hud.map_name = "New Flat Terrain World"
			Hud.map_seed = 0
			Hud.load_world()
		EDEN1:
			Hud.msg("Loading a new natural terrain world...", Debug.INFO, self)
			Hud.map_path = ""
			Hud.map_name = "New Natural Terrain World"
			Hud.map_seed = floor(rand_range(0, 9999999))
			Hud.load_world()
		EDEN2:
			Hud.msg("Loading a new natural terrain world...", Debug.INFO, self)
			Hud.map_path = ""
			Hud.map_name = "New Natural Terrain World"
			Hud.map_seed = floor(rand_range(0, 9999999))
			Hud.load_world()
