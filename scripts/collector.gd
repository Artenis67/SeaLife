extends Sprite2D

var can_move = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	var node = area.get_parent()
	node.queue_free()
	
	get_parent().incr_score()

var last_x := 0.0

func _process(delta: float) -> void:
	if can_move:
		var mouse_pos = get_global_mouse_position()
		position.x = mouse_pos.x

		if position.x < last_x:
			flip_h = false
		elif position.x > last_x:
			flip_h = true

		last_x = position.x
