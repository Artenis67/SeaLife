# Scripts/GameManager.gd
extends Node

const FIRST_STEPS_DG := preload("res://dialogues/first_steps.dialogue")
const MORNING_DG     := preload("res://dialogues/morning.dialogue")
const EVENING_DG     := preload("res://dialogues/evening.dialogue")

var intro_finished: bool = false

var _current_dialogue: DialogueResource = null


func _ready() -> void:
	check_traject_port()
	print("GameManager loaded")
	# On ne lance plus l’intro ici.
	# C'est DayFlowManager.on_time_advanced() qui appellera first_steps()
	# au premier matin (day 1).


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


func morning_dialogue() -> void:
	_current_dialogue = MORNING_DG
	_connect_dialogue_ended()
	DialogueManager.show_dialogue_balloon(MORNING_DG, "start")


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
	GameState.advance_time_of_day()


##############################
# ROUTE / PORTS
##############################

func check_traject_port() -> void:
	print("Jour :", GameState.day)
	match GameState.day:
		1:
			GameState.current_port_n = 1
			GameState.current_port = "Singapor"
			GameState.in_sea = false
		2:
			GameState.in_sea = true
		3:
			GameState.current_port_n = 2
			GameState.current_port = "Cái Mép"
			GameState.in_sea = false
		7:
			GameState.in_sea = true
		11:
			GameState.current_port_n = 3
			GameState.current_port = "Yantian"
			GameState.in_sea = false
		13:
			GameState.in_sea = true
		16:
			GameState.current_port_n = 4
			GameState.current_port = "Busan"
			GameState.in_sea = false
		18:
			GameState.in_sea = true
		20:
			GameState.current_port_n = 5
			GameState.current_port = "Yokohama"
			GameState.in_sea = false
		22:
			GameState.in_sea = true
		30:
			GameState.current_port_n = 6
			GameState.current_port = "Los Angeles"
			GameState.in_sea = false
