extends Node

func open_chat():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer").current_tab = 0

func open_world_map():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer").current_tab = 1
	
func open_region_map():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer").current_tab = 2
	
func open_chunk_map():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer").current_tab = 3
	
func open_system_status():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer").current_tab = 4
	
func open_entity_analysis():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer").current_tab = 5
	
func open_core_analysis():
	if Core.get_parent().get_node("/root/World/Interfaces/Hud"):
		Core.get_parent().get_node("/root/World/Interfaces/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer").current_tab = 6
