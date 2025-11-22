extends Control

@export var pulse_scale := 1.07        # zoom max
@export var pulse_time := 0.7          # durée aller + retour
@export var pulse_brightness := 1.15   # éclaircissement
@export var pulse_offset := 6.0        # décalage pour compenser le zoom

var tween: Tween
var base_pos: Vector2

func _start_pulse():
	_stop_pulse()

	tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	# ---- phase zoom + highlight ----
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(pulse_scale, pulse_scale), pulse_time / 2.0)
	tween.tween_property(self, "modulate",
		Color(1, 1, 1, pulse_brightness), pulse_time / 2.0)

	# ---- phase retour ----
	tween.set_parallel(false)
	tween.tween_property(self, "scale", Vector2.ONE, pulse_time / 2.0)
	tween.tween_property(self, "modulate",
		Color(1, 1, 1, 1.0), pulse_time / 2.0)


func _stop_pulse():
	if tween:
		tween.kill()
		tween = null
		scale = Vector2.ONE
		modulate = Color(1, 1, 1, 1.0)
