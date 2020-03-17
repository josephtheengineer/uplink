extends Node

############################## public variables ###############################

signal swiped(direction)
signal swiped_canceled(direction)

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3

onready var timer = $Timer
var swipe_start_position = Vector2()

onready var Hud = get_node("/root/Main Menu")




################################### signals ###################################

func _input(event): ###########################################################
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		Hud.msg("Event pressed!" + str(event.position), Debug.DEBUG, self)
		_start_detection(event.position)
	elif not timer.is_stopped():
		Hud.msg("Currently moving..." + str(event.position), Debug.DEBUG, self)
		_end_detection(event.position)

func _start_detection(position): ##############################################
	swipe_start_position = position
	timer.start()

func _end_detection(position): ################################################
	Hud.msg("Ending swipe detection...", Debug.DEBUG, self)
	timer.stop()
	var direction = (position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	
	if abs(direction.x) > abs(direction.y):
		emit_signal('swiped', Vector2(-sign(direction.x), 0.0))
	else:
		emit_signal('swiped', Vector2(0.0, -sign(direction.y)))

func _on_Timer_timeout(): #####################################################
	Hud.msg("Touch swipe timeout", Debug.DEBUG, self)
	emit_signal('swiped_canceled', swipe_start_position)



