extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/navigation_failure.dialogue")

func _ready():
	EventManager.navigation_failure.connect(_event)

func _event():
	if not DialogueManager.dialogue_ended.is_connected(_end):
		DialogueManager.dialogue_ended.connect(_end)
	DialogueManager.show_dialogue_balloon(dialogue, "start")

func _end(resource: DialogueResource):
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_end):
		DialogueManager.dialogue_ended.disconnect(_end)

	GameState.remove_money(1000)
	GameManager.event_finished()
