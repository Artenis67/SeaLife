# Scripts/PortIdleEvent.gd
extends Node

var dialogue: DialogueResource = load("res://dialogues/port_idle.dialogue")


func start_port_idle_dialogue() -> void:
	# On démarre le dialogue "journée tranquille au port"
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	DialogueManager.show_dialogue_balloon(dialogue, "start")


func _on_dialogue_ended(resource: DialogueResource) -> void:
	# On vérifie que c'est bien notre dialogue
	if resource != dialogue:
		return

	# On nettoie la connexion
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	# Quand le dialogue de midi au port est terminé,
	# on avance simplement le moment de la journée
	GameState.advance_time_of_day()
