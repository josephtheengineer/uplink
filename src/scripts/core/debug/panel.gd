extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.debug.panel",
	type = "impure",
	description = """
		
	"""
}

func open_chat():
	if Core.world.has_node("Interface/Hud/Hud/"):
		var tab_container: TabContainer = Core.world.get_node("Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_world_map():
	if Core.world.has_node("Interface/Hud/Hud/"):
		var tab_container: TabContainer = Core.world.get_node("Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_region_map():
	if Core.world.has_node("Interface/Hud/Hud/"):
		var tab_container: TabContainer = Core.world.get_node("Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_chunk_map():
	if Core.world.has_node("Interface/Hud/Hud/"):
		var tab_container: TabContainer = Core.world.get_node("Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_system_status():
	if Core.world.has_node("Interface/Hud/Hud/"):
		var tab_container: TabContainer = Core.world.get_node("Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_entity_analysis():
	if Core.world.has_node("Interface/Hud/Hud/"):
		var tab_container: TabContainer = Core.world.get_node("Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_core_analysis():
	if Core.world.has_node("Interface/Hud/Hud/"):
		var tab_container: TabContainer = Core.world.get_node("Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0
