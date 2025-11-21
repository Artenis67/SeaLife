extends Node

var dialogue := preload("res://dialogues/events/technical_issue.dialogue")

func _ready() -> void:
	EventManager.technical_issue.connect(_on_technical_issue)

func _on_technical_issue() -> void:
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	if not DialogueManager.dialogue_ended.is_connected(_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_dialogue_ended)

func _dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return
	
	if EventChoices.technical_issue_choice == "pay":
		GameState.remove_money(500)
		GameState.technical_issue = false
	else:
		GameState.technical_issue = true
	
	DialogueManager.dialogue_ended.disconnect(_dialogue_ended)
	GameManager.event_finished()
