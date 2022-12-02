extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var stats = $Stats
onready var playerDetector = $PlayerDetection
onready var sprite = $AnimatedSprite

const KNOCKBACK_FRICTION: = 200
const KNOCKBACK_AMOUNT: = 120
const MOVE_FRICTION: = 200
const ACCELERATION: = 300
const MAX_SPEED: = 50

enum { IDLE, WANDER, CHASE }

var knockback: = Vector2.ZERO
var state: = CHASE
var velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# add friction to knockback
	knockback = knockback.move_toward(Vector2.ZERO, delta * KNOCKBACK_FRICTION)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			if playerDetector.can_see_player():
				var direction = (playerDetector.player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			seek_player()
	
	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player() -> void:
	if playerDetector.can_see_player():
		state = CHASE
	else:
		state = IDLE

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	knockback = area.knockbackVector * KNOCKBACK_AMOUNT

func _on_Stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
