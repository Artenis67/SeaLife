# Scripts/EventManager.gd
extends Node

var is_in_event: bool = false
################################
# SIGNAUX D'ÉVÉNEMENTS
################################

signal lost_cargo
signal technical_issue
signal lost_money

signal small_waves
signal strange_noise
signal minor_cargo_issue
signal cook_rolling
signal sailor_sick
signal misaligned_cargo
signal deck_cleaning
signal random_inspection
signal man_overboard

# Nouveaux events ajoutés
signal reefer_issue
signal customs_inspection
signal dangerous_cargo
signal overweight_block
signal storm

signal debug_event


################################
# LISTE DES EVENTS (ID + POIDS)
################################
# Ajuste les "weight" selon ce que tu veux prioriser.
var events: Array = [
	# anciens events
	{"id": "lost_cargo",          "weight": 0.3},
	{"id": "technical_issue",     "weight": 0.1},

	# events existants simples
	{"id": "small_waves",         "weight": 0.1},
	{"id": "strange_noise",       "weight": 0.1},
	{"id": "minor_cargo_issue",   "weight": 0.1},
	{"id": "cook_rolling",        "weight": 0.1},
	{"id": "sailor_sick",         "weight": 0.1},
	{"id": "misaligned_cargo",    "weight": 0.1},
	{"id": "deck_cleaning",       "weight": 0.1},
	{"id": "random_inspection",   "weight": 0.1},
	{"id": "man_overboard",       "weight": 0.1},

	# nouveaux events ultra réalistes
	{"id": "reefer_issue",        "weight": 0.1},
	{"id": "customs_inspection",  "weight": 01000.1},
	{"id": "dangerous_cargo",     "weight": 0.1},
	{"id": "overweight_block",    "weight": 0.1},
	{"id": "storm", "weight": 0.3},

	# debug
	{"id": "debug_event",         "weight": 0.0},
]

# Liste des events déjà joués dans ce cycle (anti-répétition)
var _used_event_ids: Array = []


################################
# CHOIX ET DÉMARRAGE D'ÉVÈNEMENT
################################

func start_random_event() -> void:
	# 1) On construit une "pool" uniquement avec :
	#    - les events activés (weight > 0)
	#    - pas encore utilisés dans le cycle courant
	var pool: Array = []
	for e in events:
		var id = e["id"]
		var w  = e["weight"]
		if w > 0.0 and not (id in _used_event_ids):
			pool.append(e)

	# 2) Si la pool est vide => on a déjà tout joué au moins une fois.
	#    On reset la mémoire et on recommence avec tous les events actifs.
	if pool.is_empty():
		_used_event_ids.clear()
		for e in events:
			if e["weight"] > 0.0:
				pool.append(e)

	# 3) On calcule le poids total dans cette pool
	var total_weight := 0.0
	for e in pool:
		total_weight += e["weight"]

	if total_weight <= 0.0:
		print("EventManager: aucun event possible (total_weight = 0)")
		return

	# 4) Tirage pondéré dans la pool (sans répétition avant reset)
	var r := randf() * total_weight
	var cumulative := 0.0

	for e in pool:
		cumulative += e["weight"]
		if r <= cumulative:
			_start_event(e)
			return


func _start_event(_event: Dictionary) -> void:
	is_in_event = true
	var id = _event["id"]

	# On mémorise l'event joué pour éviter de le refaire dans le même cycle
	if not (id in _used_event_ids):
		_used_event_ids.append(id)

	emit_signal(id)
	print(id)


# compat pour vieux code
func choose_event() -> void:
	start_random_event()
