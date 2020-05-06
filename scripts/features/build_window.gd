extends Control
#warning-ignore:unused_class_variable
var script_name = "build_window"

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
