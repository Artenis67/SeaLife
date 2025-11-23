extends Control

var day_in_sea: int

@onready var day_in_sea_label = $ColorRect/Control/DayInSea/DayInSeaLabel

func _ready():
	day_in_sea = GameState.day
	animate_day_in_sea()


func animate_day_in_sea() -> void:
	var final_value := day_in_sea
	var prefix := "Jours en mer : "
	var duration := 0.8
	var step_time := 0.02
	var steps := int(duration / step_time)

	for i in range(steps):
		var value := int((i / float(steps)) * final_value)
		day_in_sea_label.text = prefix + str(value)
		await get_tree().create_timer(step_time).timeout

	# sécurité pour afficher la vraie valeur à la fin
	day_in_sea_label.text = prefix + str(final_value)
	
	await get_tree().create_timer(2).timeout
	
	ScreenFade.fade_to_scene("res://scenes/endofgame/ScoreAfficheEvents.tscn")
