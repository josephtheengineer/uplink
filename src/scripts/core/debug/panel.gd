extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.debug.panel",
	type = "impure",
	description = """
		
	"""
}

func open_chat():
	if Core.get_parent().has_node("/root/World/Interfaces/Hud/Hud/"):
		var tab_container: TabContainer = Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_world_map():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		var tab_container: TabContainer = Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_region_map():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		var tab_container: TabContainer = Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_chunk_map():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		var tab_container: TabContainer = Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_system_status():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		var tab_container: TabContainer = Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_entity_analysis():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		var tab_container: TabContainer = Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0

func open_core_analysis():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		var tab_container: TabContainer = Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer")
		tab_container.current_tab = 0
