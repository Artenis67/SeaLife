extends Control

@export var reveal_delay := 0.8        # temps d’attente après l’ouverture de la map
@export var step_delay := 0.12            # délai entre chaque affichage (tu peux changer)

var port_nodes := []                      # liste auto-récupérée de P1..P6

func _ready():
	# récupère automatiquement tous les enfants P1..P6
	port_nodes = get_children()

	# on les cache au lancement
	for p in port_nodes:
		p.visible = false


func on_map_opened():
	# Attendre la fin de l’animation du livre (0.35s)
	await get_tree().create_timer(reveal_delay).timeout

	# Affichage progressif
	for p in port_nodes:
		p.visible = true
		await get_tree().create_timer(step_delay).timeout


func on_map_closed():
	# On cache tout immédiatement
	for p in port_nodes:
		p.visible = false
