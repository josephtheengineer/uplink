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


func _on_left_button_down():
	var button: TextureButton = get_node("HBoxMiddle/Center/Left")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)
	var script = Core.scripts.chunk.generator
	for function in script.get_script_method_list():
		if script.get(function.name + "_meta") != null:
			print(function.name)


func _on_left_button_up():
	var button: TextureButton = get_node("HBoxMiddle/Center/Left")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)


func _on_right_button_down():
	var button: TextureButton = get_node("HBoxMiddle/Center2/Right")
	button.rect_min_size = button.rect_min_size - Vector2(20, 20)


func _on_right_button_up():
	var button: TextureButton = get_node("HBoxMiddle/Center2/Right")
	button.rect_min_size = button.rect_min_size + Vector2(20, 20)


