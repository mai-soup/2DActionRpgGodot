extends Node2D

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	# create grass effect
	var GrassEffect: = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	grassEffect.global_position = global_position
	# add grass effect to scene
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	# destroy the grass itself
	queue_free()
