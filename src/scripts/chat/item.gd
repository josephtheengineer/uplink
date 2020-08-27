extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "chat.item",
	type = "impure",
	description = """
		
	"""
}

func add_text(text):
	get_node("Content").add_text(text)

func delete():
	get_node("AnimationPlayer").queue("FadeOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
