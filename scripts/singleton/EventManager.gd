# Scripts/EventManager.gd
extends Node

var is_in_event: bool = false

signal lost_cargo
signal technical_issue
signal debug_event

var events: Array = [
	{"id": "lost_cargo", "weight": 0},
	{"id": "technical_issue", "weight": 0},
	{"id": "debug_event", "weight": 1},
]


# APPELÉ PAR DayFlowManager À MIDI EN MER
func start_random_event() -> void:
	var total_weight := 0.0
	for e in events:
		total_weight += e.weight

	if total_weight <= 0.0:
		print("EventManager: aucun event possible (total_weight = 0)")
		return

	var r := randf() * total_weight
	var cumulative := 0.0

	for e in events:
		cumulative += e.weight
		if r <= cumulative:
			_start_event(e)
			return


func _start_event(_event: Dictionary) -> void:
	is_in_event = true
	emit_signal(_event["id"])


# Alias si tu l’utilises encore quelque part
func choose_event() -> void:
	start_random_event()
