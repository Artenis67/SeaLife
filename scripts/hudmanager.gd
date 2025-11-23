extends Control

func _ready():
	GameState.hud_value_changed.connect(refresh_hud)
	refresh_hud()

func refresh_hud():
	$InfoContenair/CargoContainer/CargoLabel.text = "Conteneurs : " + str(GameState.cargo_count)
	# $InfoContenair/IntegrityLabel.text = "Intégrity : " + str(GameState.integrity)
	# $InfoContenair/MoralLabel.text = "Crew Moral : " + str(GameState.crew_morale)
	$InfoContenair/DayContainer/DayLabel.text = "Jours : " + str(GameState.day)
	$InfoContenair/MoneyContainer/MoneyLabel.text = "Argent : " + str(GameState.money)
