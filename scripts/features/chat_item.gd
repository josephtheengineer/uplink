extends Control

func add_text(text):
	get_node("Content").add_text(text)

func delete():
	get_node("AnimationPlayer").queue("FadeOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
