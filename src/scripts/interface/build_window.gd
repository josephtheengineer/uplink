extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.build_window",
	type = "impure",
	description = """
		
	"""
}

func create_build_window():
	var parent = get_node("MarginContainer/GridContainer")
	for _i in range(35):
		var button = TextureButton.new()
		button.texture_normal = load("res://textures/brick.png")
		button.expand = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		button.rect_min_size = Vector2(100, 100)
		button.connect("pressed", self, "_block_button_pressed", ["button"])
		parent.add_child(button)
