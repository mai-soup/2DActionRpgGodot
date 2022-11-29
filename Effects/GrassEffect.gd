extends Node2D

onready var animSprite: = $AnimatedSprite

func _ready() -> void:
	animSprite.frame = 0
	animSprite.play("Animate")


func _on_animation_finished() -> void:
	queue_free()
