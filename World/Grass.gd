extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		# create grass effect
		var GrassEffect: = load("res://Effects/GrassEffect.tscn")
		var grassEffect = GrassEffect.instance()
		grassEffect.global_position = global_position
		
		var world = get_tree().current_scene
		world.add_child(grassEffect)
		# destroy the grass itself
		queue_free()
