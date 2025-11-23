extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/customs_inspection.dialogue")

func _ready() -> void:
	EventManager.customs_inspection.connect(_on_customs_inspection)


func _on_customs_inspection() -> void:
	EventChoices.customs_inspection_choice = ""
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_customs_ended):
		DialogueManager.dialogue_ended.connect(_on_customs_ended)


func _on_customs_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_customs_ended):
		DialogueManager.dialogue_ended.disconnect(_on_customs_ended)

	match EventChoices.customs_inspection_choice:
		"cooperate":
			GameState.remove_money(500)
		"limit":
			GameState.remove_cargo(randi_range(50, 150))
		_:
			pass

	GameManager.event_finished()
