extends Control

var day_in_sea
var total_cargo
var events
var final_money

@onready var day_in_sea_label = $DayInSea/DayInSeaLabel
@onready var total_cargo_label = $TotalCargo/TotalCargoLabel
@onready var events_label = $TotalEvent/TotalEventLabel
@onready var final_money_label = $FinamMoney/FinalMoneyLabel


func _ready():
	day_in_sea = GameState.day
	total_cargo = GameState.total_cargo
	events = GameState.total_events
	final_money = GameState.money
	
	start_sequence()


func start_sequence() -> void:
	await animate_label(day_in_sea_label, day_in_sea, "  Jours en mer : ")
	await animate_label(total_cargo_label, total_cargo, "  EVP transportés : ")
	await animate_label(events_label, events, "  Événements totaux : ")
	await animate_label(final_money_label, final_money, "  Crédits finaux : ")


# Fonction générique pour animer un label de 0 → valeur finale
func animate_label(label: Label, final_value: int, prefix: String) -> void:
	var duration := 0.8                 # durée totale de l'animation
	var step_time := 0.02               # fréquence de rafraîchissement
	var steps := int(duration / step_time)
	
	for i in range(steps):
		var value := int((i / float(steps)) * final_value)
		label.text = prefix + str(value)
		await get_tree().create_timer(step_time).timeout
	
	label.text = prefix + str(final_value)  # sécurité pour afficher la vraie valeur
