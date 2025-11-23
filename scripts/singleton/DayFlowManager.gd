# Scripts/DayFlowManager.gd
extends Node

###################################
# APPELÉ AUTOMATIQUEMENT PAR GameState
###################################
# GameState.advance_time_of_day() et GameState.set_time_of_day()
# appellent cette fonction après avoir modifié time_of_day.
func on_time_advanced() -> void:
	GameManager.check_traject_port()

	match GameState.time_of_day:
		GameState.TIME_MORNING:
			_handle_morning()
		GameState.TIME_NOON:
			_handle_noon()
		GameState.TIME_EVENING:
			_handle_evening()
		_:
			_handle_night() # normalement jamais utilisé pour l’instant


###################################
# LOGIQUE PAR MOMENT DE LA JOURNÉE
###################################

func _handle_morning() -> void:
	if GameState.day == 1 and not GameManager.intro_finished:
		GameManager.first_steps()
		return

	if GameState.in_sea:
		var rng := randi() % 7
		if rng == 0:
			GameManager.morning_dialogue("trouble")  # 1/7
		else:
			GameManager.morning_dialogue("sea")
	else:
		GameManager.morning_dialogue("port")


func _handle_noon() -> void:
	if GameState.in_sea:
		# Midi en mer → event aléatoire
		EventManager.start_random_event()
	else:
		if GameState.current_port == "Singapor":
			PortIdleEvent.start_port_idle_dialogue("singapor")
		else:
			PortIdleEvent.start_port_idle_dialogue("start")


func _handle_evening() -> void:
	# Dialogue du soir (peut dépendre de in_sea plus tard si tu veux)
	GameManager.evening_dialogue()


func _handle_night() -> void:
	# Tu as dit que tu gérerais la nuit à la main plus tard.
	# Pour l'instant, on ne fait rien ici.
	pass
