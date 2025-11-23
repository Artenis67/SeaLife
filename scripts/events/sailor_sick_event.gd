extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/sailor_sick.dialogue")

func _ready() -> void:
	EventManager.sailor_sick.connect(_on_event)

func _on_event() -> void:
	EventChoices.sailor_sick_choice = ""
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return	

	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	match EventChoices.sailor_sick_choice:
		"rest":
			GameState.crew_morale -= 1
		"work":
			pass # si tu veux ajouter un risque plus tard

	GameManager.event_finished()
