#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.hud",
	description = """
		
	"""
}

const DEFAULT_HUD = {
	meta = {
		system = "interface",
		type = "hud",
		id = "Hud"
	}
}

static func create(): #################################################################
	Core.client.data.subsystem.interface.Link.create(DEFAULT_HUD.duplicate(true))

static func process_hud(hud): #########################################################
	if hud:
		Core.scripts.core.debug.info.player_move_update(hud)
		Core.scripts.core.debug.info.action_mode_update(hud)
		Core.scripts.core.debug.info.frame_update(hud)
		Core.scripts.core.debug.info.world_stats_update(hud)
