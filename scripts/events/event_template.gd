extends Node

var dialogue = load("res://dialogues/event.dialogue")

func _ready():
	EventManager.lost_money.connect(event)

func event():
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	DialogueManager.dialogue_ended.connect(_dialogue_ended)
func _dialogue_ended():
	GameManager.event_finished()
