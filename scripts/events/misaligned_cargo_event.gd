extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/misaligned_cargo.dialogue")

func _ready() -> void:
	EventManager.misaligned_cargo.connect(_on_event)

func _on_event() -> void:
	EventChoices.misaligned_cargo_choice = ""
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return	

	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	match EventChoices.misaligned_cargo_choice:
		"secure":
			GameState.remove_money(300)
		"risk":
			GameState.remove_cargo(randi_range(100,300))

	GameManager.event_finished()
