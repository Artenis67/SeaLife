extends Control

signal map_opened
signal map_closed

@export var anim_duration: float = 0.35

# on récupère la petite carte
@onready var map_rect: TextureRect = $BookContainer/BookIcon

var is_open: bool = false
var closed_pos: Vector2
var closed_size: Vector2
var open_pos: Vector2
var open_size: Vector2


func _ready() -> void:
	# État "fermé" = ce que tu as mis dans l'éditeur
	closed_pos = map_rect.position
	closed_size = map_rect.size

	# État "ouvert" = grande carte quasi plein écran
	var vp_size: Vector2 = get_viewport_rect().size
	open_size = vp_size * 0.7              # 80% de la taille écran (tu peux ajuster)
	open_pos = Vector2(-70, -50)

	# On commence fermé
	map_rect.position = closed_pos
	map_rect.size = closed_size


func _process(delta: float) -> void:
	# TAB = action "ui_focus_next" par défaut
	if Input.is_action_just_pressed("ui_focus_next"):
		_toggle_book()
		_toggle_button()

func _toggle_button():
	$BookContainer/Text.visible = !$BookContainer/Text.visible

func _toggle_book() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	if is_open:
		# fermer : revenir à la petite icône	
		tween.tween_property(map_rect, "position", closed_pos, anim_duration)
		tween.tween_property(map_rect, "size", closed_size, anim_duration)
		map_closed.emit()
	else:
		# ouvrir : zoom au centre de l'écran
		tween.tween_property(map_rect, "position", open_pos, anim_duration)
		tween.tween_property(map_rect, "size", open_size, anim_duration)
		map_opened.emit()
		
	is_open = !is_open
