extends Control

signal finished(score: float)

@export var rounds_count: int = 10
@export var delay_between_rounds: float = 0.25

# Sprites de flèches
@export var arrow_up_texture: Texture2D
@export var arrow_down_texture: Texture2D
@export var arrow_left_texture: Texture2D
@export var arrow_right_texture: Texture2D

@onready var final_score_label: Label    = $FinalLabel
@onready var arrow_sprite: Sprite2D      = $Arrow
@onready var info_label: Label           = $InfoLabel
@onready var instructions_label: Label   = $InstructionsLabel

var _directions := ["up", "down", "left", "right"]
var _current_direction: String = ""
var _current_round: int = 0
var _waiting_input: bool = false

var _round_start_time: float = 0.0
var _total_reaction_time: float = 0.0

var _base_scale: Vector2
var _base_modulate: Color


func _ready() -> void:
	_base_scale = arrow_sprite.scale
	_base_modulate = arrow_sprite.modulate

	if instructions_label:
		instructions_label.text = "Clique le plus vite possible sur les flèches pour aider le bateau à rester droit."
	if info_label:
		info_label.text = "Prépare-toi, la tempête arrive..."

	# On masque la flèche pendant le décompte
	arrow_sprite.visible = false

	_start_countdown()


# ----------------------
# DÉCOMPTE AVANT JEU
# ----------------------
func _start_countdown() -> void:
	await _run_countdown(5)
	arrow_sprite.visible = true
	_start_next_round()


func _run_countdown(total: int) -> void:
	for i in range(total, 0, -1):
		if info_label:
			info_label.text = "La tempête commence dans %d..." % i

			# petite anim de "pop" sur le texte
			info_label.scale = Vector2.ONE * 1.25
			var t := create_tween()
			t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			t.tween_property(info_label, "scale", Vector2.ONE, 0.3)

		await get_tree().create_timer(1.0).timeout

	if info_label:
		info_label.text = "C'est parti !"


# ----------------------
# LOGIQUE DES ROUNDS
# ----------------------
func _start_next_round() -> void:
	if _current_round >= rounds_count:
		_end_minigame()
		return
	
	_current_round += 1
	_waiting_input = true

	# Direction aléatoire
	_current_direction = _directions[randi() % _directions.size()]
	_update_arrow_texture()

	# Position aléatoire de la flèche dans l'écran
	_randomize_arrow_position()

	# Reset apparence et anim d'apparition
	arrow_sprite.scale = _base_scale * 0.7
	arrow_sprite.modulate = Color(_base_modulate.r, _base_modulate.g, _base_modulate.b, 0.0)
	_play_appear_anim()

	_round_start_time = Time.get_ticks_msec() / 1000.0

	if info_label:
		info_label.text = "Correction %d / %d" % [_current_round, rounds_count]


func _update_arrow_texture() -> void:
	match _current_direction:
		"up":
			arrow_sprite.texture = arrow_up_texture
		"down":
			arrow_sprite.texture = arrow_down_texture
		"left":
			arrow_sprite.texture = arrow_left_texture
		"right":
			arrow_sprite.texture = arrow_right_texture
		_:
			arrow_sprite.texture = null


func _randomize_arrow_position() -> void:
	# On utilise la taille du viewport pour rester dans l'écran
	var vp_size: Vector2 = get_viewport_rect().size

	# Marges pour éviter d'être trop collé aux bords
	var margin_ratio := 0.15
	var min_x := vp_size.x * margin_ratio
	var max_x := vp_size.x * (1.0 - margin_ratio)
	var min_y := vp_size.y * margin_ratio
	var max_y := vp_size.y * (1.0 - margin_ratio)

	var pos_x := randf_range(min_x, max_x)
	var pos_y := randf_range(min_y, max_y)

	# Pour un Sprite2D, la position correspond au centre
	arrow_sprite.position = Vector2(pos_x, pos_y)


func _play_appear_anim() -> void:
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_property(arrow_sprite, "scale", _base_scale, 0.15)
	t.parallel().tween_property(arrow_sprite, "modulate:a", _base_modulate.a, 0.15)


func _unhandled_input(event: InputEvent) -> void:
	if not _waiting_input:
		return
	
	if event.is_action_pressed("ui_up"):
		_on_direction_input("up")
	elif event.is_action_pressed("ui_down"):
		_on_direction_input("down")
	elif event.is_action_pressed("ui_left"):
		_on_direction_input("left")
	elif event.is_action_pressed("ui_right"):
		_on_direction_input("right")


func _on_direction_input(dir: String) -> void:
	if not _waiting_input:
		return
	
	_waiting_input = false

	var now := Time.get_ticks_msec() / 1000.0
	var reaction := now - _round_start_time
	_total_reaction_time += reaction

	var correct := (dir == _current_direction)
	if not correct:
		# petite pénalité si mauvaise flèche
		_total_reaction_time += 0.5
		if info_label:
			info_label.text = "Mauvaise correction ! (+0.5s)"
	else:
		if info_label:
			info_label.text = "Bonne correction (%.2fs)" % reaction

	# petite anim de feedback au clic, puis round suivant
	_play_click_anim(correct)


# ----------------------
# ANIM SUR LE CLIC
# ----------------------
func _play_click_anim(correct: bool) -> void:
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Couleurs plus accentuées
	var target_scale := _base_scale * 1.2 if correct else _base_scale * 0.85
	var target_color := Color(0.3, 1.0, 0.3, _base_modulate.a) if correct \
		else Color(1.0, 0.3, 0.3, _base_modulate.a)

	t.tween_property(arrow_sprite, "scale", target_scale, 0.08)
	t.parallel().tween_property(arrow_sprite, "modulate", target_color, 0.08)
	t.tween_property(arrow_sprite, "scale", _base_scale, 0.08)
	t.parallel().tween_property(arrow_sprite, "modulate", _base_modulate, 0.08)

	t.finished.connect(_on_click_anim_finished)


func _on_click_anim_finished() -> void:
	_wait_and_next_round()


func _wait_and_next_round() -> void:
	# petite pause avant la prochaine flèche
	await get_tree().create_timer(delay_between_rounds).timeout
	_start_next_round()


# ----------------------
# FIN DU MINI-JEU
# ----------------------
func _end_minigame() -> void:
	arrow_sprite.visible = false

	if final_score_label:
		final_score_label.visible = true
		final_score_label.text = "Temps total : %.2fs" % _total_reaction_time

		# Taille de départ
		var start_size := final_score_label.get_theme_font_size("font_size")
		var end_size := start_size + 20  # augmente de 20px (tu peux changer)

		var t := create_tween()
		t.tween_method(
			func(value):
				final_score_label.add_theme_font_size_override("font_size", value),
			start_size,
			end_size,
			5.0  # durée 5 secondes
		)

	await get_tree().create_timer(5.0).timeout

	finished.emit(_total_reaction_time)
