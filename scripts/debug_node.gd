extends Node2D

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_L:
		GameState.advance_time_of_day()
		print("key pressed")
