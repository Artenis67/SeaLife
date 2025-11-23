extends Control

@export var show_duration: float = 4.0   # temps d’affichage
@export var anim_time: float = 0.35      # durée de l’anim d’entrée/sortie

@onready var port_name: Label = $PortName
var last_port_name

var shown_pos: Vector2       # position quand la notif est visible
var hidden_pos: Vector2      # position cachée (un peu au-dessus)
var current_tween: Tween     # pour éviter de stack les tweens


func _ready() -> void:
	# on mémorise la position normale de la notif
	shown_pos = position
	# position "cachée" (tu peux changer le Vector2)
	hidden_pos = shown_pos + Vector2(0, -40)

	# on commence hors écran / invisible
	position = hidden_pos
	modulate.a = 0.0
	visible = false

	GameState.change_time_of_the_day.connect(check_if_boat_in_port)


func check_if_boat_in_port() -> void:
	if !GameState.in_sea:
		cast_notification()


func cast_notification() -> void:
	port_name.text = GameState.current_port
	if last_port_name != GameState.current_port:
		_show_notification()
	last_port_name = GameState.current_port


func _show_notification() -> void:
	visible = true

	if current_tween:
		current_tween.kill()

	# reset état de départ pour l’anim
	position = hidden_pos
	modulate.a = 0.0

	current_tween = create_tween()
	current_tween.tween_property(self, "position", shown_pos, anim_time) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	current_tween.parallel().tween_property(self, "modulate:a", 1.0, anim_time)

	_schedule_hide()


func _schedule_hide() -> void:
	await get_tree().create_timer(show_duration).timeout
	_hide_notification()


func _hide_notification() -> void:
	if current_tween:
		current_tween.kill()

	current_tween = create_tween()
	current_tween.tween_property(self, "position", hidden_pos, anim_time) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	current_tween.parallel().tween_property(self, "modulate:a", 0.0, anim_time)
	current_tween.tween_callback(_on_hide_done)


func _on_hide_done() -> void:
	visible = false
