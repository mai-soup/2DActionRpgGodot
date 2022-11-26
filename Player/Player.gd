extends KinematicBody2D

onready var animationPlayer: = $AnimationPlayer

const ACCELERATION: = 500
const MAX_SPEED: = 80
const FRICTION: = 500

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_vector: = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - \
		Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - \
		Input.get_action_strength("move_up")
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# reassign velocity from move and slide's remnant after collision	
	velocity = move_and_slide(velocity)
