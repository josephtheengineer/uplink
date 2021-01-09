extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.eden1.background",
	type = "impure",
	description = """
		
	"""
}

onready var clouds: Node2D = get_node("Clouds")
onready var ground: Node2D = get_node("Ground")
onready var animation: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	animation.play("PinWheel")

func _process(delta):
	ground.position = Vector2(-get_viewport().get_visible_rect().size.x, get_viewport().get_visible_rect().size.y)
