# Scripts/GameManager.gd
extends Node

signal fade_launched

const FIRST_STEPS_DG        := preload("res://dialogues/first_steps.dialogue")
const EVENING_DG            := preload("res://dialogues/evening.dialogue")

const MORNING_AT_SEA_DG     := preload("res://dialogues/morning_at_sea.dialogue")
const MORNING_IN_PORT_DG    := preload("res://dialogues/morning_in_port.dialogue")
const MORNING_TROUBLE_DG    := preload("res://dialogues/morning_trouble.dialogue")

var intro_finished: bool = false

var _current_dialogue: DialogueResource = null


func _ready() -> void:
	print("GameManager loaded")
	# Aucune logique de jeu ici.
	# Tout démarre avec GameState.start_new_game() depuis la main scene.



##############################
# DIALOGUES
##############################

func _connect_dialogue_ended() -> void:
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func first_steps() -> void:
	_current_dialogue = FIRST_STEPS_DG
	_connect_dialogue_ended()
	DialogueManager.show_dialogue_balloon(FIRST_STEPS_DG, "start")


## Matin : mode = "sea" / "port" / "trouble"
func morning_dialogue(mode := "sea") -> void:
	var resource: DialogueResource

	match mode:
		"sea":
			resource = MORNING_AT_SEA_DG
		"port":
			resource = MORNING_IN_PORT_DG
		"trouble":
			resource = MORNING_TROUBLE_DG
		_:
			resource = MORNING_AT_SEA_DG

	_current_dialogue = resource
	_connect_dialogue_ended()
	DialogueManager.show_dialogue_balloon(resource, "start")


func evening_dialogue() -> void:
	_current_dialogue = EVENING_DG
	_connect_dialogue_ended()
	DialogueManager.show_dialogue_balloon(EVENING_DG, "start")


func _on_dialogue_ended(resource: DialogueResource) -> void:
	# On ignore les dialogues qui ne viennent pas de nous
	if resource != _current_dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	# Logique spécifique selon le dialogue
	if resource == FIRST_STEPS_DG:
		intro_finished = true
	elif resource == EVENING_DG:
		fade_launched.emit()
		_current_dialogue = null
		return

	# On nettoie le pointeur
	_current_dialogue = null

	# Dans tous les cas : un dialogue fini = on avance au moment suivant
	GameState.advance_time_of_day()

##############################
# FIN D'ÉVÈNEMENT / MINI-JEU
##############################

func event_finished() -> void:
	# — À APPELER à la fin d'un event ou d'un mini-jeu —
	EventManager.is_in_event = false
	GameState.total_events = GameState.total_events + 1
	GameState.advance_time_of_day()



##############################
# ROUTE / PORTS
##############################

func restock_cargo():
	GameState.add_cargo(randi_range(GameState.cargo_unload * 0.8, GameState.cargo_unload))

func unload_and_earn():
	GameState.remove_cargo(GameState.cargo_unload)
	GameState.add_money(GameState.money_earned)

func cargo_unload_random():
	GameState.cargo_unload = floor(GameState.cargo_count * 0.7)
	GameState.money_earned = GameState.cargo_unload * floor(randf_range(1.3,2))

func check_traject_port() -> void:
	print("Jour :", GameState.day)
	match GameState.day:
		1:
			GameState.current_port_n = 1
			GameState.current_port = "Singapor"
			GameState.in_sea = false
			cargo_unload_random()
		2:
			GameState.in_sea = true
		6:
			GameState.next_day_in_port = true
		7:
			GameState.next_day_in_port = false
			GameState.current_port_n = 2
			GameState.current_port = "Cái Mép"
			GameState.in_sea = false
			cargo_unload_random()
		8:
			GameState.in_sea = true
		10:
			GameState.next_day_in_port = true	
		11:
			GameState.next_day_in_port = false
			GameState.current_port_n = 3
			GameState.current_port = "Yantian"
			GameState.in_sea = false
			cargo_unload_random()
		12:
			GameState.in_sea = true
		15:
			GameState.next_day_in_port = true
		16:
			GameState.next_day_in_port = false
			GameState.current_port_n = 4
			GameState.current_port = "Busan"
			GameState.in_sea = false
			cargo_unload_random()
		17:
			GameState.in_sea = true
		19:
			GameState.next_day_in_port = true
		20:
			GameState.next_day_in_port = false
			GameState.current_port_n = 5
			GameState.current_port = "Yokohama"
			GameState.in_sea = false
			cargo_unload_random()
		21:
			GameState.in_sea = true
		27:
			GameState.next_day_in_port = true
		28:
			GameState.next_day_in_port = false
			GameState.current_port_n = 6
			GameState.current_port = "Los Angeles"
			GameState.in_sea = false
			cargo_unload_random()

func finish_game():
	ScreenFade.fade_to_scene("res://scenes/endofgame/ScoreAfficheDay.tscn")
