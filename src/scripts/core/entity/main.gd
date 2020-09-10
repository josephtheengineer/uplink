class_name Entity
extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.entity.main",
	type = "impure",
	description = """
		generic entity type
	"""
}

var components := Dictionary()

func destory(): ################################################################
	Core.emit_signal("object_unloaded", meta)
	queue_free()
	Core.emit_signal("object_unloaded", meta)

func set_component(path: String, value): #######################################
	Core.scripts.dictionary.main.setInDict(components, path.split(".", false), value)
	components = components
