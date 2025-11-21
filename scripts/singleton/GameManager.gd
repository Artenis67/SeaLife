extends Node

const FIRST_STEPS_DG := preload("res://dialogues/first_steps.dialogue")
const MORNING_DG := preload("res://dialogues/morning.dialogue")
const EVENING_DG := preload("res://dialogues/evening.dialogue")

var intro_finished = false
var day_finished = false

func _ready() -> void:
	print("GameManager loaded")
	if GameState.day == 1:
		first_steps()


func first_steps() -> void:
	DialogueManager.show_dialogue_balloon(FIRST_STEPS_DG, "start")
	DialogueManager.dialogue_ended.connect(_on_first_steps_dialogue_ended)


func _on_first_steps_dialogue_ended(resource: DialogueResource) -> void:
	if resource != FIRST_STEPS_DG:
		return
	DialogueManager.dialogue_ended.disconnect(_on_first_steps_dialogue_ended)
	
	_on_first_steps_finished()


func _on_first_steps_finished() -> void:
	intro_finished = true
	GameState.advance_time_of_day()
	check_day_cycle()

func check_day_cycle():
	print("CheckDayCycle Of Game Manager launched")
	if GameState.time_of_day == 1 && intro_finished:
		morning_dialogue()
	if GameState.time_of_day == 2:
		EventManager.choose_event()
	if GameState.time_of_day == 3:
		evening_dialogue()

func morning_dialogue():
	DialogueManager.show_dialogue_balloon(MORNING_DG, "start")
	DialogueManager.dialogue_ended.connect(morning_dialogue_finished)

func morning_dialogue_finished(resource: DialogueResource):
	if resource != MORNING_DG:
		return
	DialogueManager.dialogue_ended.disconnect(evening_dialogue_finished)
	GameState.advance_time_of_day()
	check_day_cycle()

func evening_dialogue():
	DialogueManager.show_dialogue_balloon(EVENING_DG, "start")
	DialogueManager.dialogue_ended.connect(evening_dialogue_finished)

func evening_dialogue_finished(resource: DialogueResource):
	if resource != EVENING_DG:
		return
	DialogueManager.dialogue_ended.disconnect(evening_dialogue_finished)
	GameState.advance_time_of_day()
	check_day_cycle()

func event_finished():
	GameState.advance_time_of_day()
	check_day_cycle()

func check_traject_port():
	print("Jour :" + str(GameState.day))
	match GameState.day:
		1:
			GameState.current_port_n = 1
			GameState.current_port = "Singapor"
			GameState.in_sea = false
		2:
			GameState.in_sea = true
		6:
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
