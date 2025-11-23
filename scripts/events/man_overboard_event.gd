extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/man_overboard.dialogue")

func _ready() -> void:
	EventManager.man_overboard.connect(_on_event)


func _on_event() -> void:
	# On reset le choix
	EventChoices.man_overboard_choice = ""

	DialogueManager.show_dialogue_balloon(dialogue, "start")

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	match EventChoices.man_overboard_choice:
		"rescue":
			GameState.add_money(3000)
		"leave":
			pass

	GameManager.event_finished()
