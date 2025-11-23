extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/overweight_block.dialogue")

func _ready() -> void:
	EventManager.overweight_block.connect(_on_overweight_block)


func _on_overweight_block() -> void:
	EventChoices.overweight_block_choice = ""
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_overweight_ended):
		DialogueManager.dialogue_ended.connect(_on_overweight_ended)


func _on_overweight_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_overweight_ended):
		DialogueManager.dialogue_ended.disconnect(_on_overweight_ended)

	match EventChoices.overweight_block_choice:
		"reorganize":
			GameState.remove_money(600)
		"ignore":
			pass # Tu peux ajouter un malus futur pendant une tempête
		_:
			pass

	GameManager.event_finished()
