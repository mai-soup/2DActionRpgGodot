extends KinematicBody2D

const FRICTION: = 200
const KNOCKBACK_AMOUNT: = 120

var knockback: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# add friction to knockback
	knockback = knockback.move_toward(Vector2.ZERO, delta * FRICTION)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	knockback = area.knockbackVector * KNOCKBACK_AMOUNT
