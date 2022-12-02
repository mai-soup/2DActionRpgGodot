extends Area2D

const HitEffect: = preload("res://Effects/HitEffect.tscn")

export var show_hit: = true

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if !show_hit:
		return
	
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
