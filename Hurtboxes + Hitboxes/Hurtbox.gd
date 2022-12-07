extends Area2D

signal invincibility_started
signal invincibility_ended

const HitEffect: = preload("res://Effects/HitEffect.tscn")
onready var timer: = $Timer
onready var collShape: = $CollisionShape2D

var is_invincible: = false setget set_invincible

func create_hit_effect() -> void:
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func set_invincible(value: bool) -> void:
	is_invincible = value

func start_invincibility(duration: float) -> void:
	self.is_invincible = true
	emit_signal("invincibility_started")
	timer.start(duration)

func _on_Timer_timeout() -> void:
	self.is_invincible = false
	emit_signal("invincibility_ended")

func _on_Hurtbox_invincibility_started() -> void:
	collShape.set_deferred("disabled", true)

func _on_Hurtbox_invincibility_ended() -> void:
	collShape.set_deferred("disabled", false)
