extends CanvasLayer

@onready var rect: ColorRect = $ColorRect
@export var fade_time: float = 0.5  # durée du fondu

func _ready() -> void:
	rect.visible = true
	rect.modulate.a = 0.0


func fade_in() -> void:
	# scène déjà chargée, on fait apparaître l'image en fondue
	rect.visible = true
	var t := create_tween()
	t.tween_property(rect, "modulate:a", 0.0, fade_time).from(1.0)
	await t.finished
	rect.visible = false


func fade_to_scene(scene_path: String) -> void:
	# fondu au noir
	rect.visible = true
	var t := create_tween()
	t.tween_property(rect, "modulate:a", 1.0, fade_time).from(0.0)
	await t.finished

	# changement de scène
	get_tree().change_scene_to_file(scene_path)

	# on attend un frame pour être sûr que la nouvelle scène est affichée
	await get_tree().process_frame

	# fondu de retour
	fade_in()
