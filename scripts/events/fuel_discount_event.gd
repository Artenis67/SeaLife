extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/fuel_discount.dialogue")

func _ready():
	EventManager.fuel_discount.connect(_event)

func _event():
	if not DialogueManager.dialogue_ended.is_connected(_end):
		DialogueManager.dialogue_ended.connect(_end)
	DialogueManager.show_dialogue_balloon(dialogue, "start")

func _end(resource: DialogueResource):
	if resource != dialogue:
		return

	DialogueManager.dialogue_ended.disconnect(_end)
	GameState.add_money(1000)
	GameManager.event_finished()
