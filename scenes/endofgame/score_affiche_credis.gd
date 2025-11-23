extends Control

@onready var label = $ColorRect/Control/FinalMoney/FinalMoneyLabel

func _ready():
	animate_value(GameState.money, "Crédits finaux : ")


func animate_value(final_value: int, prefix: String) -> void:
	var duration := 0.8
	var step_time := 0.02
	var steps := int(duration / step_time)

	for i in range(steps):
		var value := int((i / float(steps)) * final_value)
		label.text = prefix + str(value)
		await get_tree().create_timer(step_time).timeout

	label.text = prefix + str(final_value)
	
	await get_tree().create_timer(2).timeout
	
	ScreenFade.fade_to_scene("res://scenes/end_of_the_game.tscn")
