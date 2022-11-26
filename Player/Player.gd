extends KinematicBody2D

onready var animPlayer: = $AnimationPlayer
onready var animTree: = $AnimationTree
onready var animState = animTree.get("parameters/playback")

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
		# set up blend positions for both animations
		animTree.set("parameters/Idle/blend_position", input_vector)
		animTree.set("parameters/Run/blend_position", input_vector)
		# play the run animations
		animState.travel("Run")
		# accelerate
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# play the idle animations
		animState.travel("Idle")
		# decelerate
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# reassign velocity from move and slide's remnant after collision	
	velocity = move_and_slide(velocity)
