extends Node2D

# preload the scene so godot can attempt to share it so we don't load it again
# every time a new grass effect is needed
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	# create grass effect
	var grassEffect = GrassEffect.instance()
	grassEffect.global_position = global_position
	# add grass effect to scene
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	# destroy the grass itself
	queue_free()
