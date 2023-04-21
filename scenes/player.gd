extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const GRAVITY = 400
const ACCELERATION = 1000

const MAX_JUMP_TIME = 0.2
const MAX_AIRBORNE_TIME = 0.1

var current_jump_time = 0
var current_airborne_time = 0
var jumping = false

const MAX_HEALTH = 100
var health = 100:
	set(value):
		health = value
		hud.set_health(health)
	get:
		return health

var Enemy = preload("res://scenes/enemy.tscn")

@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var audio_stream_player = $AudioStreamPlayer
@onready var attack_area_2d = $Pivot/AttackArea2D
@onready var hud = $CanvasLayer/HUD
@onready var bullet_spawn = $Pivot/BulletSpawn


@export var Bullet: PackedScene 



func _ready():
	animation_tree.active = true
#	Engine.time_scale = 0.2
	attack_area_2d.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if is_on_floor():
		current_airborne_time = 0

	if Input.is_action_just_pressed("jump") and current_airborne_time < MAX_AIRBORNE_TIME:
		jumping = true
		current_jump_time = 0
		Game.jumps += 1
		audio_stream_player.play()
	
	if jumping and current_jump_time <= MAX_JUMP_TIME:
		velocity.y = JUMP_VELOCITY
	
	current_jump_time += delta
	current_airborne_time += delta
	
	if Input.is_action_just_released("jump"):
		jumping = false
	

	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)

	move_and_slide()

	if Input.is_action_just_pressed("spawn"):
		_spawn()
		
	if Input.is_action_just_pressed("attack"):
		_attack()
	
	if Input.is_action_just_pressed("fire"):
		_fire()
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print(collision.get_collider().name)
		
	
	# animation
	
	if is_on_floor():
		if abs(velocity.x) > 10 or move_input:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	
	if move_input:
		pivot.scale.x = sign(move_input)


func _spawn():
	var enemy = Enemy.instantiate()
	enemy.global_position = get_global_mouse_position()
	enemy.rotation = (get_global_mouse_position() - global_position).angle() + PI / 2
	get_parent().add_child(enemy)


func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage()
	if body is CharacterBody2D:
		var character = body as CharacterBody2D
		character.velocity = (character.global_position - global_position).normalized() * 500


func _attack():
	playback.call_deferred("travel", "attack")


func _fire():
#	if Game.bullet:
#		return
	if !Bullet:
		return
	var bullet = Bullet.instantiate()
	bullet.rotation = bullet_spawn.global_position.direction_to(get_global_mouse_position()).angle()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_spawn.global_position
	
	

func take_damage():
	if health <= 0:
		return
	health = max(health - 25, 0)
	print(health)
