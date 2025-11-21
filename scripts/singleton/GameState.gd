# Scripts/GameState.gd
extends Node

signal hud_value_changed
signal change_time_of_the_day

var day: int = 1
var time_of_day: int = 1  # 1:"morning", 2:"noon", 3:"evening"
var current_port: String = ""
var current_port_n: int = 0
var in_sea: bool = false

var cargo_count: int = 8000
var cargo_max: int = 8000
var cargo_rare: int = 0
var integrity: int = 100
var crew_morale: int = 80
var money: int = 0

var technical_issue: bool = false


##############################
# CARGO
##############################

func add_cargo(amount: int) -> void:
	cargo_count += amount
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

# ⚠️ NE PAS SUPPRIMER : tous tes vieux scripts continuent d'appeler ça.
# On garde la même signature, mais à la fin on délègue la logique à DayFlowManager.
func advance_time_of_day() -> void:
	if time_of_day < 3:
		time_of_day += 1
	else:
		advance_day()
		time_of_day = 1

	change_time_of_the_day.emit()
	print(time_of_day)

	# NEW : on prévient le DayFlowManager que le temps a avancé.
	# Tous les events / dialogues automatiques partent d'ici.
	DayFlowManager.on_time_advanced()


func advance_day() -> void:
	day += 1
	hud_value_changed.emit()


func set_time_of_day(time: int) -> void:
	if time < 4:
		time_of_day = time
	else:
		print("Time too high")
		time_of_day = 1

	change_time_of_the_day.emit()

	# Si quelqu'un change le moment directement, on applique quand même la logique.
	DayFlowManager.on_time_advanced()


##############################
# MONEY (ARGENT)
##############################

func add_money(amount: int) -> void:
	print(money)
	money += amount
	hud_value_changed.emit()


func remove_money(amount: int) -> void:
	money -= amount
	hud_value_changed.emit()


func set_money(amount: int) -> void:
	money = amount
	hud_value_changed.emit()
