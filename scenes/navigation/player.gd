extends CharacterBody2D

@export var speed = 100
@export var acceleration = 500

@export var target: Node2D

@onready var agent = $NavigationAgent2D
@onready var timer = $Timer


func _ready():
	_update_target()
	timer.timeout.connect(_update_target)
	NavigationServer2D.map_set_edge_connection_margin(get_world_2d().navigation_map, 20)
	agent.velocity_computed.connect(_on_velocity_computed)

func _physics_process(delta):
	var next_position = agent.get_next_path_position()
	var move_direction = global_position.direction_to(next_position)
	
	if agent.is_navigation_finished():
		move_direction = Vector2.ZERO
	
	var new_velocity = velocity.move_toward(move_direction * speed, acceleration)
	agent.set_velocity(new_velocity)
	
#	print(agent.get_current_navigation_path())


func _update_target():
	if is_instance_valid(target):
		agent.target_position = target.global_position


func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
