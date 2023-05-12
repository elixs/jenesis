class_name Player
extends CharacterBody2D

enum State {
	MOVE,
	WALL_CLIMB,
	SWIM,
}

const SPEED = 100.0
const JUMP_SPEED = -200.0
const GRAVITY = 400
const ACCELERATION = 1000

const MAX_JUMP_TIME = 0.2
const MAX_AIRBORNE_TIME = 0.1

const WALL_SPEED = 50.0

var current_jump_time = 0
var current_airborne_time = 0
var jumping = false

var pickable: Pickable = null
var grabbed = false

var display_name = "meh":
	set(value):
		display_name = value
		print(display_name)


var kills = 0:
	set(value):
		kills = value
		hud.set_kills(kills)

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
@onready var ray_cast_2d = $Pivot/RayCast2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var wall_check = $Pivot/WallCheck
@onready var pickable_marker = $Pivot/PickableMarker
@onready var pickable_area = $PickableArea


@export var Bullet: PackedScene
@export var Explosion: PackedScene


var _state = State.MOVE


func _ready():
	animation_tree.active = true
#	Engine.time_scale = 0.2
	attack_area_2d.body_entered.connect(_on_body_entered)
	hud.show()
	pickable_area.body_entered.connect(_on_pickable_enter)
	pickable_area.body_exited.connect(_on_pickable_exit)
#	load_data()
	print(display_name)

func _physics_process(delta):
	match _state:
		State.MOVE:
			_move(delta)
		State.WALL_CLIMB:
			_wall_climb(delta)
		State.SWIM:
			_swim(delta)
#	print(velocity)

	if Input.is_action_just_pressed("interact") and pickable:
		grabbed = !grabbed
		pickable.freeze = grabbed
		
	if pickable and grabbed:
		pickable.global_position = lerp(pickable.global_position, pickable_marker.global_position, 0.1)


func _input(event):
	if event.is_action_pressed("save"):
#		save_data()
		save_config()
	if event.is_action_pressed("load"):
#		load_data()
		load_config()
	if event.is_action_pressed("random"):
		display_name = str(randi() % 101)
	
	
func _move(delta):
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
		velocity.y = JUMP_SPEED
	
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
#		print(collision.get_collider().name)
		
		
	# state
	
	if ray_cast_2d.is_colliding() and not is_on_floor():
		set_state(State.WALL_CLIMB)
		return;
	
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

func _wall_climb(delta):
	var move_input = Input.get_axis("move_up", "move_down")
	if not wall_check.is_colliding():
		move_input = max(move_input, 0)
	velocity.y = move_input * WALL_SPEED
	
	move_and_slide()
	
	# state
	
	if Input.is_action_just_pressed("jump"):
		set_state(State.MOVE)


func _swim(delta):
	pass


func _spawn():
	var enemy = Enemy.instantiate()
	enemy.global_position = get_global_mouse_position()
	enemy.rotation = (get_global_mouse_position() - global_position).angle() + PI / 2
	get_parent().add_child(enemy)


func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage()
		_spawn_explosion(body.global_position, body)
		kills += 1
		
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


func set_state(value):
	var current_state = _state
	var new_state = value
	
	match current_state:
		State.MOVE:
			pass
		State.WALL_CLIMB:
			if new_state == State.MOVE:
				var direction = Vector2(pivot.scale.x, -1).normalized()
				jumping = true
#				velocity = direction * (JUMP_SPEED + WALL_SPEED)
		State.SWIM:
			pass
	
	match new_state:
		State.MOVE:
			current_jump_time = 0
		State.WALL_CLIMB:
			playback.travel("wall_climb")
			velocity = Vector2.ZERO
			var normal = ray_cast_2d.get_collision_normal()
			var pos = ray_cast_2d.get_collision_point()
			var capsule = collision_shape_2d.shape as CapsuleShape2D
			global_position.x = (pos + normal * capsule.radius).x
			pivot.scale.x *= -1
		State.SWIM:
			pass
	
	_state = new_state

func _spawn_explosion(pos, node):
	var explosion = Explosion.instantiate()
	node.add_child(explosion)
	explosion.global_position = pos


func _on_pickable_enter(body: Node):
	if body is Pickable:
		pickable = body


func _on_pickable_exit(body: Node):
	if body == pickable and not grabbed:
		pickable = null


func save_data():
	var data = {
		"kills": kills
	}
	
#	var file = FileAccess.open("user://data.json", FileAccess.WRITE)
#	var file = FileAccess.open_encrypted_with_pass("user://data.save", FileAccess.WRITE, "meh")
	var file = FileAccess.open("user://data.binary", FileAccess.WRITE)

	if not file:
		return
#	file.store_string(JSON.stringify(data))
	file.store_var(kills)
	file.store_var(display_name)


func load_data():
#	var file = FileAccess.open("user://data.json", FileAccess.READ)
#	var file = FileAccess.open_encrypted_with_pass("user://data.save", FileAccess.READ, "meh")
	var file = FileAccess.open("user://data.binary", FileAccess.READ)
	if not file:
		return
#	var data = JSON.parse_string(file.get_as_text())
#	kills = data.kills
	kills = file.get_var()
	display_name = file.get_var()


func save_config():
	var config_file = ConfigFile.new()
	config_file.set_value("settings", "language", Game.language)
	config_file.save("user://config.cfg")


func load_config():
	var config_file = ConfigFile.new()
	config_file.load("user://config.cfg")
	var language = config_file.get_value("settings", "language")
	print(language)
