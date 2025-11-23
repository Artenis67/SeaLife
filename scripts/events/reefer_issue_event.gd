extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/reefer_issue.dialogue")

func _ready() -> void:
	EventManager.reefer_issue.connect(_on_reefer_issue)


func _on_reefer_issue() -> void:
	EventChoices.reefer_issue_choice = ""
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_reefer_ended):
		DialogueManager.dialogue_ended.connect(_on_reefer_ended)


func _on_reefer_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_reefer_ended):
		DialogueManager.dialogue_ended.disconnect(_on_reefer_ended)

	match EventChoices.reefer_issue_choice:
		"repair":
			GameState.remove_money(800)
		"ignore":
			GameState.remove_cargo(100)
		_:
			pass

	GameManager.event_finished()
