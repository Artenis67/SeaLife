extends Node2D

@export var spawn_interval: float = 1      # une tête toutes les X secondes
@export var speed: float = 200.0             # vitesse de défilement
@export var textures: Array[Texture2D] = []  # tes portraits

@export var _rotation: int

var path: Path2D
var timer: Timer
var followers: Array[PathFollow2D] = []

func _ready() -> void:
	path = get_parent() as Path2D

	# Timer qui spawn une tête régulièrement
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_spawn_head)
	add_child(timer)


func _process(delta: float) -> void:
	# On fait avancer toutes les têtes
	for follower in followers:
		follower.progress += speed * delta

	# 💥 On supprime celles qui sont arrivées au bout
	# (on les stocke avant pour éviter de modifier la liste en pleine boucle)
	var to_remove := []

	for follower in followers:
		if follower.progress_ratio >= 1.0:
			to_remove.append(follower)

	# Suppression propre
	for f in to_remove:
		followers.erase(f)
		f.queue_free()


func _spawn_head() -> void:
	if textures.is_empty():
		return

	# 1) Créer le PathFollow2D
	var follower := PathFollow2D.new()
	follower.progress_ratio = 10.0
	follower.loop = false
	path.add_child(follower)
	followers.append(follower)

	# 2) Créer le Sprite2D avec une tête aléatoire
	var sprite := Sprite2D.new()
	sprite.texture = textures.pick_random()
	sprite.centered = true

	# 💡 Tes réglages :
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # pixel art "nearest"
	sprite.scale = Vector2(4, 4)                        # x4.17 en X et Y
	sprite.rotation_degrees = _rotation                          # rotation de 90° vers la droite

	follower.add_child(sprite)
