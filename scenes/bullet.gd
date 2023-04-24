extends Area2D

const SPEED = 200

@onready var timer = $Timer


func _ready():
	body_entered.connect(_on_body_entered)
	Game.bullet = true
	timer.timeout.connect(queue_free)


func _physics_process(delta):
	var velocity = transform.x * SPEED
	position += velocity * delta
	

func _exit_tree():
	Game.bullet = false


func _on_body_entered(body: Node):
	if body is Player:
		return
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
