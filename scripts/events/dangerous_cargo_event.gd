extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/dangerous_cargo.dialogue")

func _ready() -> void:
	EventManager.dangerous_cargo.connect(_on_dangerous_cargo)


func _on_dangerous_cargo() -> void:
	EventChoices.dangerous_cargo_choice = ""
	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_dangerous_ended):
		DialogueManager.dialogue_ended.connect(_on_dangerous_ended)


func _on_dangerous_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_dangerous_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dangerous_ended)

	match EventChoices.dangerous_cargo_choice:
		"report":
			GameState.remove_cargo(50)
			GameState.remove_money(300)
		"hide":
			pass # Tu pourras ajouter une conséquence plus tard (event rare)
		_:
			pass

	GameManager.event_finished()
