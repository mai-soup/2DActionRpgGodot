extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

onready var animPlayer: = $AnimationPlayer
onready var animTree: = $AnimationTree
onready var animState = animTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtBox: = $Hurtbox
onready var blinkAnimPlayer: = $BlinkAnimPlayer
var stats = PlayerStats

const ACCELERATION: = 500
const MAX_SPEED: = 80
const FRICTION: = 500
const ROLL_FACTOR: = 1.5

enum { MOVE, ROLL, ATTACK }

var state: = MOVE
var velocity: = Vector2.ZERO
var rollVector: = Vector2.DOWN

func _ready() -> void:
	randomize()
	stats.connect("no_health", self, "queue_free")
	# only activate animation tree when the game is started
	animTree.active = true
	swordHitbox.knockbackVector = rollVector

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta: float) -> void:
	var input_vector: = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - \
		Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - \
		Input.get_action_strength("move_up")
	
	if input_vector != Vector2.ZERO:
		# set up blend positions for all animations
		animTree.set("parameters/Idle/blend_position", input_vector)
		animTree.set("parameters/Run/blend_position", input_vector)
		animTree.set("parameters/Attack/blend_position", input_vector)
		animTree.set("parameters/Roll/blend_position", input_vector)
		# set roll vector to the input direction
		rollVector = input_vector
		swordHitbox.knockbackVector = rollVector
		# play the run animations
		animState.travel("Run")
		# accelerate
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# play the idle animations
		animState.travel("Idle")
		# decelerate
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(_delta: float) -> void:
	velocity = Vector2.ZERO
	animState.travel("Attack")

func roll_state(_delta: float) -> void:
	# roll doesnt have acceleration, just goes straight to max speed x roll const
	velocity = rollVector * MAX_SPEED * ROLL_FACTOR
	animState.travel("Roll")
	move()
	
func attack_anim_finished() -> void:
	state = MOVE

func roll_anim_finished() -> void:
	state = MOVE

func move() -> void:
	# reassign velocity from move and slide's remnant after collision	
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	hurtBox.start_invincibility(0.5)
	hurtBox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started() -> void:
	blinkAnimPlayer.play("Start")

func _on_Hurtbox_invincibility_ended() -> void:
	blinkAnimPlayer.play("Stop")
