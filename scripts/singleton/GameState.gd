# Scripts/GameState.gd
extends Node

signal hud_value_changed
signal change_time_of_the_day

# Moments de la journée
const TIME_MORNING := 1
const TIME_NOON := 2
const TIME_EVENING := 3

var day: int = 1
var time_of_day: int = TIME_MORNING  # 1:"morning", 2:"noon", 3:"evening"
var current_port: String = ""
var current_port_n: int = 0
var in_sea: bool = false
var next_day_in_port: bool = false

var cargo_count: int = 0
var cargo_unload: int
var cargo_max: int = 8000
var cargo_rare: int = 0
var integrity: int = 100
var crew_morale: int = 80
var money: int = 2000
var money_earned: int

var technical_issue: bool = false

## Score

@onready var total_cargo = 0
@onready var total_events = 0

func _ready() -> void:
	pass
	# Jeu lancé avec un boutton
	# On lance la logique du "moment courant" dès le début du jeu
	# DayFlowManager.on_time_advanced()

func start_new_game() -> void:
	# Reset de base
	day = 1
	time_of_day = TIME_MORNING
	current_port = ""
	current_port_n = 0
	in_sea = false

	# Mettre à jour port/mer en fonction du day 1
	GameManager.check_traject_port()

	# Prévenir le HUD que tout a été initialisé
	change_time_of_the_day.emit()

	# Lancer la logique du moment courant (day 1, morning)
	DayFlowManager.on_time_advanced()


##############################
# CARGO
##############################

func add_cargo(amount: int) -> void:
	cargo_count += amount
	total_cargo += amount
	hud_value_changed.emit()


func remove_cargo(amount: int) -> void:
	cargo_count -= amount
	hud_value_changed.emit()


func add_rare_cargo(amount: int) -> void:
	cargo_rare += amount


func remove_rare_cargo(amount: int) -> void:
	cargo_rare -= amount


func clear_rare_cargo() -> void:
	cargo_rare = 0


##############################
# INTÉGRITÉ (COQUE)
##############################

func damage_integreity(amount: int) -> void:
	integrity -= amount
	hud_value_changed.emit()


func heal_integrity(amount: int) -> void:
	integrity += amount
	hud_value_changed.emit()


##############################
# TEMPS (JOUR / MOMENT)
##############################

func advance_time_of_day() -> void:
	if time_of_day < TIME_EVENING:
		if day == 28:
			GameManager.finish_game()
			return
		else:
			time_of_day += 1
	else:
		advance_day()
		time_of_day = TIME_MORNING

	GameManager.check_traject_port()
	change_time_of_the_day.emit()
	DayFlowManager.on_time_advanced()


func advance_day() -> void:
	day += 1
	hud_value_changed.emit()

func set_time_of_day(time: int) -> void:
	if time < 1 or time > TIME_EVENING:
		print("Time too high or invalid, reset to morning")
		time_of_day = TIME_MORNING
	else:
		time_of_day = time

	change_time_of_the_day.emit()
	DayFlowManager.on_time_advanced()


##############################
# MONEY (ARGENT)
##############################

func add_money(amount: int) -> void:
	money += amount
	hud_value_changed.emit()


func remove_money(amount: int) -> void:
	money -= amount
	hud_value_changed.emit()


func set_money(amount: int) -> void:
	money = amount
	hud_value_changed.emit()
