extends KinematicBody2D

const ACCELERATION: = 500
const MAX_SPEED: = 80
const FRICTION: = 500

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_vector: = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# reassign velocity from move and slide's remnant after collision	
	velocity = move_and_slide(velocity)
