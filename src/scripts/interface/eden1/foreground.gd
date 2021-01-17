extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.eden1.foreground",
	type = "impure",
	description = """
		
	"""
}

func _ready():
	self.visible = true
	get_parent().get_node("SharedWorlds").visible = false
	update_worlds_list()

func _on_delete_button_down():
	var button: TextureButton = get_node("HBoxTop/Center/Delete")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_delete_button_up():
	var button: TextureButton = get_node("HBoxTop/Center/Delete")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)


func _on_create_button_down():
	var button: TextureButton = get_node("HBoxTop/Center2/Create")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_create_button_up():
	var button: TextureButton = get_node("HBoxTop/Center2/Create")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)


func _on_upload_button_down():
	var button: TextureButton = get_node("HBoxBottom/Center/Upload")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_upload_button_up():
	var button: TextureButton = get_node("HBoxBottom/Center/Upload")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)


func _on_option_button_down():
	var button: TextureButton = get_node("HBoxBottom/Center2/Option")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_option_button_up():
	var button: TextureButton = get_node("HBoxBottom/Center2/Option")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)


func _on_download_button_down():
	var button: TextureButton = get_node("HBoxBottom/Center3/Download")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_download_button_up():
	var button: TextureButton = get_node("HBoxBottom/Center3/Download")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)
	open_shared_worlds()


func _on_left_button_down():
	var button: TextureButton = get_node("HBoxMiddle/Center/Left")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_left_button_up():
	var button: TextureButton = get_node("HBoxMiddle/Center/Left")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)
	
	if index - 1 >= 0 and index - 1 < worlds_list.size():
		index -=1
		update_worlds_list()


func _on_right_button_down():
	var button: TextureButton = get_node("HBoxMiddle/Center2/Right")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_right_button_up():
	var button: TextureButton = get_node("HBoxMiddle/Center2/Right")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)
	
	if index + 1 >= 0 and index + 1 < worlds_list.size():
		index +=1
		update_worlds_list()

var worlds_list := [
	"test1",
	"test2",
	"test3"
]

var index := 0

func update_worlds_list():
	var worlds: HBoxContainer = get_node("HBoxMiddle/VBox/Worlds")
	var status: RichTextLabel = get_node("HBoxMiddle/VBox/Status")
	var world_name: RichTextLabel = get_node("HBoxMiddle/VBox/Name")
	var unselected_texture := load("res://aux/assets/textures/ui/eden2/ipad/main_menu/ipad~world_unselected.png")
	var selected_texture := load("res://aux/assets/textures/ui/eden2/ipad/main_menu/ipad~world_selected.png")
	
	status.bbcode_text = "[center] Choose a world to load [/center]"
	world_name.bbcode_text = "[center] " + worlds_list[index] + " [/center]"
	
	
	for button in worlds.get_children():
		remove_child(button)
		button.queue_free()
	
	for i in range(-2, 3):
		var button := TextureButton.new()
		var center := CenterContainer.new()
		center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		center.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		if i == 0:
			button.texture_normal = selected_texture
		elif index + i >= 0 and index + i < worlds_list.size():
			button.texture_normal = unselected_texture
		
		button.rect_min_size = Vector2(50, 50)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
		center.add_child(button)
		worlds.add_child(center)

func list_functions(script):
	#var script = Core.scripts.chunk.generator
	for function in script.get_script_method_list():
		if script.get(function.name + "_meta") != null:
			print(function.name)

func open_shared_worlds():
	self.visible = false
	get_parent().get_node("SharedWorlds").visible = true
