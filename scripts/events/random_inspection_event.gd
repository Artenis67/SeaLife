extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/random_inspection.dialogue")

func _ready() -> void:
	EventManager.random_inspection.connect(_on_event)

func _on_event() -> void:
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return	

	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	GameManager.event_finished()
