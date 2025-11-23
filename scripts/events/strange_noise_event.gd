extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/strange_noise.dialogue")

func _ready() -> void:
	EventManager.strange_noise.connect(_on_strange_noise)


func _on_strange_noise() -> void:
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	GameManager.event_finished()
