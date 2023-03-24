extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -200.0
const GRAVITY = 400
const ACCELERATION = 1000


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)

	move_and_slide()
