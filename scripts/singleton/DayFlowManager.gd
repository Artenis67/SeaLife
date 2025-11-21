extends Node

@onready var game_state := GameState
@onready var event_manager := EventManager


func _ready() -> void:
	pass
###################################
# APPELÉ AUTOMATIQUEMENT PAR GameState
###################################
# GameState.advance_time_of_day() et GameState.set_time_of_day()
# appellent cette fonction après avoir modifié time_of_day.
func on_time_advanced() -> void:
	GameManager.check_traject_port()
	match game_state.time_of_day:
		1:
			_handle_morning()
		2:
			_handle_noon()
		3:
			_handle_evening()
		_:
			_handle_night()


###################################
# LOGIQUE PAR MOMENT DE LA JOURNÉE
###################################

func _handle_morning() -> void:
	# Tu pourras ajouter tes trucs de matin ici plus tard
	pass

func _handle_evening() -> void:
	# Idem pour le soir
	pass

func _handle_night() -> void:
	# Si un jour tu utilises 4 = nuit
	pass

###################################
# LE CAS SPÉCIAL : MIDI
###################################

func _handle_noon() -> void:
	if game_state.in_sea:
		# Midi en mer → event aléatoire
		event_manager.start_random_event()
	else:
		# Midi au port → pas d'event, juste un dialogue "rien de spécial"
		PortIdleEvent.start_port_idle_dialogue()
