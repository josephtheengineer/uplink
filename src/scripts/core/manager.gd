#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.manager",
	description = """
		
	"""
}

################################################################################

static func get_entities_with(component: String): #####################################
	if Core.world.has_node(component):
		return Core.world.get_node(component).get_children()
	else:
		return false
