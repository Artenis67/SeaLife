extends Node2D

signal finished

@onready var path_spawn = $Path2D
@onready var spawn_location = $Path2D/SpawnLocation

@export var cargo1: PackedScene
@export var cargo2: PackedScene
var falling_cargo

@export var score = 0

@onready var collector = $collector

@export var pc0: Texture2D 
@export var pc1: Texture2D
@export var pc2: Texture2D 
@export var pc3: Texture2D 
@export var pc4: Texture2D 
@export var pc5: Texture2D 
@export var pc6: Texture2D 
@export var pc7: Texture2D

func get_random_location():
	spawn_location.progress_ratio = randf()
	var location = spawn_location.position
	return location

func spawn_cargo():
	if randi_range(0,2) == 1:
		falling_cargo = cargo1.instantiate()
	else:
		falling_cargo = cargo2.instantiate()
	
	falling_cargo.position = get_random_location()
	
	$cargo_parent.add_child(falling_cargo)


func _on_spawner_timer_timeout():
	spawn_cargo()

func incr_score():
	score += 1 
	check_score()

func check_score():
	match score:
		0:
			collector.texture = pc0
		1:
			collector.texture = pc1
		3:
			collector.texture = pc2
		5:
			collector.texture = pc3
		7:
			collector.texture = pc4
		10:
			collector.texture = pc5
		12:
			collector.texture = pc6
		15:
			collector.texture = pc7
			game_ended()

func game_ended():
	finished.emit()
	$collector.can_move = false
	$SpawnerTimer.stop()
	for cargo in $cargo_parent.get_children():
		cargo.fall_speed = 0
