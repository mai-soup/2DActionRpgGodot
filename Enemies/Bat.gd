extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var stats = $Stats
onready var playerDetector = $PlayerDetection
onready var sprite = $AnimatedSprite
onready var hurtBox: = $Hurtbox
onready var softColl: = $SoftCollision
onready var wanderController: = $WanderController

const KNOCKBACK_FRICTION: = 200
const KNOCKBACK_AMOUNT: = 120
const MOVE_FRICTION: = 200
const ACCELERATION: = 300
const MAX_SPEED: = 50

enum { IDLE, WANDER, CHASE }

var knockback: = Vector2.ZERO
export var state: = CHASE
var velocity: = Vector2.ZERO

func _ready() -> void:
	pick_random_rest_state()

func _physics_process(delta: float) -> void:
	# add friction to knockback
	knockback = knockback.move_toward(Vector2.ZERO, delta * KNOCKBACK_FRICTION)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
			seek_player()
			
			if (wanderController.get_time_left() == 0):
				pick_random_rest_state()
		WANDER:
			seek_player()
			
			if (wanderController.get_time_left() == 0):
				pick_random_rest_state()
			
			accelerate_towards_point(wanderController.target_position, delta, 0.5)
			
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED  * delta:
				pick_random_rest_state()
				wanderController.update_target_position()
				
		CHASE:
			if playerDetector.can_see_player():
				accelerate_towards_point(playerDetector.player.global_position, delta)
			seek_player()
	
	orient_sprite()
	velocity += softColl.get_push_vector() * delta * KNOCKBACK_AMOUNT * 2
	velocity = move_and_slide(velocity)

func seek_player() -> void:
	if playerDetector.can_see_player():
		state = CHASE
	else:
		state = WANDER

func orient_sprite() -> void:
	sprite.flip_h = velocity.x < 0

func accelerate_towards_point(point: Vector2, delta: float, factor: float = 1) -> void:
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED * factor, ACCELERATION * delta)
	orient_sprite()

func pick_random_rest_state() -> void:
	var state_list: = [IDLE, WANDER]
	state_list.shuffle()
	wanderController.start_wander_timer(rand_range(1, 3))
	state = state_list.pop_front()

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	knockback = area.knockbackVector * KNOCKBACK_AMOUNT
	hurtBox.start_invincibility(0.5)
	hurtBox.create_hit_effect()

func _on_Stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
