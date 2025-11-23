extends CanvasLayer

@onready var rect: ColorRect = $FadeLayer
var fade_timer: Timer

signal fade_mid

func _ready() -> void:
	# Timer créé dans le script
	fade_timer = Timer.new()
	fade_timer.one_shot = true
	fade_timer.wait_time = 1.0
	add_child(fade_timer)
	fade_timer.timeout.connect(_on_fade_finished)

	rect.modulate.a = 0.0

	GameManager.connect("fade_launched", full_fade_transition)


func full_fade_transition() -> void:
	# Tween simple : 0 → 1 → 0 en 1 seconde
	var t := create_tween()
	t.tween_property(rect, "modulate:a", 1.0, 0.5)  # transparent -> noir
	t.tween_callback(Callable(self, "_on_mid_fade")) # au milieu, quand c'est noir
	t.tween_property(rect, "modulate:a", 0.0, 0.5)  # noir -> transparent

	# Timer pour le callback final
	fade_timer.start()


func _on_mid_fade() -> void:
	# Ici l'écran est complètement noir
	fade_mid.emit()


func _on_fade_finished() -> void:
	rect.modulate.a = 0.0   # sécurité
	GameState.advance_time_of_day()
