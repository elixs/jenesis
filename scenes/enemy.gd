class_name Enemy

extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 10


func _ready():
	print("Enemy")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	
func take_damage():
	var current_modulate = modulate
	modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	modulate = current_modulate
