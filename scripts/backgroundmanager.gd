extends Node2D

@export var bg_1: Texture2D
@export var bg_2: Texture2D
@export var bg_3: Texture2D
@export var bg_4: Texture2D
@export var bg_p: Texture2D

@onready var bg_texture_rect := $Sky

func _ready():
	GameState.change_time_of_the_day.connect(update_bg)

func update_bg():
	match GameState.time_of_day:
		1:
			bg_texture_rect.texture = bg_1
			$Label.text = "Matin"
		2:
			bg_texture_rect.texture = bg_2
			$Label.text = "Midi"
		3:
			bg_texture_rect.texture = bg_3
			$Label.text = "Soir"
		4:
			bg_texture_rect.texture = bg_4
			$Label.text = "Nuit"

	if !GameState.in_sea:
		bg_texture_rect.texture = bg_p
	print("Navire en mer : " + str(GameState.in_sea))


func _on_canvas_layer_fade_mid():
	if GameState.next_day_in_port == true:
		bg_texture_rect.texture = bg_p
	else:
		bg_texture_rect.texture = bg_1
	$Label.text = "Matin"
