extends Node

var dialogue: DialogueResource = load("res://dialogues/events/lost_cargo.dialogue")

@export var HUD: Control
var mini_game_instance: Node = null   

func _ready():
	EventManager.lost_cargo.connect(event)


func event():
	EventChoices.lost_cargo_choice = ""

	DialogueManager.dialogue_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
	DialogueManager.show_dialogue_balloon(dialogue, "start")


func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	match EventChoices.lost_cargo_choice:
		"save":
			_start_lost_cargo_minigame()
			HUD.visible = false
		"nothing":
			_apply_cargo_loss()
			GameManager.event_finished()
		_:
			_apply_cargo_loss()
			GameManager.event_finished()


func _start_lost_cargo_minigame() -> void:
	mini_game_instance = preload("res://scenes/minigames/CargoDrop.tscn").instantiate()
	add_child(mini_game_instance)
	mini_game_instance.finished.connect(_on_minigame_finished, CONNECT_ONE_SHOT)


func _apply_cargo_loss() -> void:
	GameState.remove_cargo(randi_range(200,400))


func _on_minigame_finished() -> void:
	EventChoices.cargo_drop_result = randi_range(100, 200)
	EventChoices.last_result = EventChoices.cargo_drop_result

	DialogueManager.dialogue_ended.connect(_on_result_dialogue_ended, CONNECT_ONE_SHOT)
	DialogueManager.show_dialogue_balloon(dialogue, "result")


func _on_result_dialogue_ended(resource: DialogueResource) -> void:
	if resource != dialogue:
		return

	GameState.remove_cargo(EventChoices.cargo_drop_result)
	EventChoices.cargo_drop_result = 0

	if mini_game_instance and is_instance_valid(mini_game_instance):
		mini_game_instance.queue_free()
		mini_game_instance = null

	HUD.visible = true

	GameManager.event_finished()
