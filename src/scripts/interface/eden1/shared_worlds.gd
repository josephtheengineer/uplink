extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.eden1.foreground",
	type = "impure",
	description = """
		
	"""
}

func _ready():
	var worlds = {
		test1 = "",
		test2 = "",
		test3 = ""
	}
	display_worlds(worlds, get_node("VBox/Worlds"))

func display_worlds(worlds: Dictionary, parent: Node):
	var unselected_texture := load("res://aux/assets/textures/ui/eden2/ipad/main_menu/ipad~world_unselected.png")
	var selected_texture := load("res://aux/assets/textures/ui/eden2/ipad/main_menu/ipad~world_selected.png")
	
	
	for button in parent.get_children():
		remove_child(button)
		button.queue_free()
	
	for i in worlds.size():
		var button := TextureButton.new()
		var center := CenterContainer.new()
		center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		center.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		button.rect_min_size = Vector2(50, 50)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
		center.add_child(button)
		parent.add_child(center)


func _on_back_button_down():
	var button: TextureButton = get_node("VBox/Header/HBox/Back")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_back_button_up():
	var button: TextureButton = get_node("VBox/Header/HBox/Back")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)
	self.visible = false
	get_parent().get_node("VBox").visible = true


func _on_left_button_down():
	var button: TextureButton = get_node("VBox/Header/Center/VBox/HBox/Left")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_left_button_up():
	var button: TextureButton = get_node("VBox/Header/Center/VBox/HBox/Left")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)


func _on_right_button_down():
	var button: TextureButton = get_node("VBox/Header/Center/VBox/HBox/Right")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_right_button_up():
	var button: TextureButton = get_node("VBox/Header/Center/VBox/HBox/Right")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)
