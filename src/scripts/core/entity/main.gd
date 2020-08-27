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

export var components := Dictionary()

func destory(): ################################################################
	Core.emit_signal("object_unloaded", self)
	queue_free()
	Core.emit_signal("object_unloaded", self)

func set_component(path: String, value): #######################################
	Core.aux.dictonary.functions.setInDict(components, path.split(".", false), value)
	components = components
