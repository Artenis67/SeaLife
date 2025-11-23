extends Control

@export var main_scene: PackedScene 

func _on_StartButton_pressed() -> void:
	ScreenFade.fade_to_scene("res://scenes/intro_scene.tscn")
