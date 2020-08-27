#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.hud",
	description = """
		
	"""
}

static func create(): #################################################################
	var hud = Dictionary()
	hud.name_id = "hud"
	hud.type = "interface"
	hud.id = "Hud"
	
	Core.scripts.core.manager.create(hud)

static func process_hud(hud): #########################################################
	if hud:
		Core.scriptss.core.debug.info.player_move_update(hud)
		Core.scriptss.core.debug.info.action_mode_update(hud)
		Core.scriptss.core.debug.info.frame_update(hud)
		Core.scriptss.core.debug.info.world_stats_update(hud)
