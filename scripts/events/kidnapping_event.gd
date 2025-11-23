extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/kidnapping.dialogue")

func _ready():
	EventManager.kidnapping.connect(_event)

func _event():
	EventChoices.kidnap_choice = ""

	if not DialogueManager.dialogue_ended.is_connected(_after):
		DialogueManager.dialogue_ended.connect(_after)

	DialogueManager.show_dialogue_balloon(dialogue, "start")

func _after(resource: DialogueResource):
	if resource != dialogue:
		return
	
	DialogueManager.dialogue_ended.disconnect(_after)

	match EventChoices.kidnap_choice:
		"pay":
			GameState.remove_money(2000)
		_:
			pass

	GameManager.event_finished()
