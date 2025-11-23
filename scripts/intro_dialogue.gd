extends Node

var dialogue: DialogueResource = load("res://dialogues/intro.dialogue")

func _ready():
	start_intro_dialogue()

func start_intro_dialogue() -> void:
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	DialogueManager.show_dialogue_balloon(dialogue, "start")


func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	# On nettoie la connexion
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	# Quand le dialogue d'intro est terminé, on fade vers la MainScene
	ScreenFade.fade_to_scene("res://scenes/MainScene.tscn")
