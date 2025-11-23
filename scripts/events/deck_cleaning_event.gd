extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/deck_cleaning.dialogue")

func _ready() -> void:
	EventManager.deck_cleaning.connect(_on_event)

func _on_event() -> void:
	EventChoices.deck_cleaning_choice = ""
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return	

	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	match EventChoices.deck_cleaning_choice:
		"clean":
			GameState.remove_money(800)

	GameManager.event_finished()
