extends Node2D

var fall_speed

func _ready():
	fall_speed = randf_range(150, 300)

func _process(delta: float) -> void:
	position.y += fall_speed * delta
