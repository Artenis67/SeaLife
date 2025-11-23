extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/quick_contract.dialogue")

func _ready():
	EventManager.quick_contract.connect(_event)

func _event():
	EventChoices.quick_contract_choice = ""

	if not DialogueManager.dialogue_ended.is_connected(_after_choice):
		DialogueManager.dialogue_ended.connect(_after_choice)

	DialogueManager.show_dialogue_balloon(dialogue, "start")

func _after_choice(resource: DialogueResource):
	if resource != dialogue:
		return

	DialogueManager.dialogue_ended.disconnect(_after_choice)

	match EventChoices.quick_contract_choice:
		"add":
			GameState.add_cargo(3)
		_:
			pass

	GameManager.event_finished()
