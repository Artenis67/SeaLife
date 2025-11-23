extends Node

var dialogue: DialogueResource = preload("res://dialogues/events/storm.dialogue")

@export var HUD: Control
@export var _TileMap: TileMap

var mini_game_instance: Node = null


func _ready() -> void:
	# IMPORTANT : tu dois avoir signal storm dans EventManager
	EventManager.storm.connect(_on_storm_event)


func _on_storm_event() -> void:
	# Lancement du premier dialogue
	if not DialogueManager.dialogue_ended.is_connected(_on_intro_dialogue_finished):
		DialogueManager.dialogue_ended.connect(_on_intro_dialogue_finished)

	DialogueManager.show_dialogue_balloon(dialogue, "start")


func _on_intro_dialogue_finished(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_intro_dialogue_finished):
		DialogueManager.dialogue_ended.disconnect(_on_intro_dialogue_finished)

	_start_minigame()


func _start_minigame() -> void:
	var scene := preload("res://scenes/minigames/StormMinigame.tscn")
	mini_game_instance = scene.instantiate()
	add_child(mini_game_instance)

	# On masque HUD + map
	if HUD:
		HUD.visible = false
	if _TileMap:
		_TileMap.visible = false

	# Le mini-jeu doit émettre : finished(score)
	mini_game_instance.finished.connect(_on_minigame_finished)


func _on_minigame_finished(score: float) -> void:
	# -----------------------------------------
	# CALCUL SIMPLE : perte = floor(score * 100)
	# -----------------------------------------
	var lost := int(floor(score * 100.0))

	# Clamp pour éviter de perdre + que le cargo restant
	lost = clamp(lost, 0, GameState.cargo_count)

	# Stocker les résultats (pour le dialogue)
	EventChoices.storm_reaction_time = score
	EventChoices.storm_lost_cargo = lost

	# Appliquer la perte réelle
	GameState.remove_cargo(lost)

	# Nettoyer mini-jeu
	if mini_game_instance and is_instance_valid(mini_game_instance):
		mini_game_instance.queue_free()
	mini_game_instance = null

	# Réafficher HUD
	if HUD:
		HUD.visible = true
	if _TileMap:
		_TileMap.visible = true

	# Dialogue de résultat
	if not DialogueManager.dialogue_ended.is_connected(_on_result_dialogue_finished):
		DialogueManager.dialogue_ended.connect(_on_result_dialogue_finished)

	DialogueManager.show_dialogue_balloon(dialogue, "result")


func _on_result_dialogue_finished(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	if DialogueManager.dialogue_ended.is_connected(_on_result_dialogue_finished):
		DialogueManager.dialogue_ended.disconnect(_on_result_dialogue_finished)

	# FIN DE L’ÉVÈNEMENT
	GameManager.event_finished()
