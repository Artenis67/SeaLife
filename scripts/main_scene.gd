extends Node2D  # ou Control selon ta root

func _ready() -> void:
	GameState.start_new_game()
