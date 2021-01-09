extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.eden1.foreground",
	type = "impure",
	description = """
		
	"""
}


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
