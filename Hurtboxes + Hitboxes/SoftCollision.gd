extends Area2D

func is_colliding() -> bool:
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector() -> Vector2:
	if !is_colliding():
		return Vector2.ZERO
	
	var area = get_overlapping_areas()[0]
	var push_vector = area.global_position.direction_to(global_position)
	push_vector = push_vector.normalized()
	
	return push_vector
