#warning-ignore:unused_class_variable
var script_name = "hud"

var Manager = preload("res://scripts/features/manager.gd").new()
var DebugInfo = preload("res://scripts/features/debug_info.gd").new()

func create():
	var hud = Dictionary()
	hud.name_id = "hud"
	hud.type = "interface"
	hud.id = "Hud"
	
	Manager.create(hud)

func process_hud(hud):
	if hud:
		DebugInfo.player_move_update(hud)
		DebugInfo.action_mode_update(hud)
		DebugInfo.frame_update(hud)
		DebugInfo.world_stats_update(hud)