extends CharacterBody2D

const SPEED = 50
const GRAVITY = 400

@onready var detection_area = $DetectionArea

var target: Player = null

func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	_follow(delta)
	
	move_and_slide()
	


func _follow(delta):
	if not target:
		return
	var direction = target.global_position.x - global_position.x
	velocity.x = sign(direction) * SPEED

func _on_body_entered(body: Node):
	var player = body as Player
	if player:
		target = player

func _on_body_exited(body: Node):
	if body == target:
		target = null
