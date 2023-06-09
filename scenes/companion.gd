extends CharacterBody2D

@onready var small_cog_right = $SmallCogRight
@onready var small_cog_bottom = $SmallCogBottom
@onready var big_cog = $BigCog

var target: Node2D
var tween: Tween

@export var speed = 300
@export var acceleration = 1000

enum State {
	FOLLOW,
	MOVE
}

var state: State = State.FOLLOW:
	set(value):
		var current_state = state
		var next_state = value
		
		if next_state == State.FOLLOW:
			if tween:
				tween.set_speed_scale(1)
				velocity = Vector2.ZERO
				
		
		state = next_state


func _ready():
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(small_cog_bottom, "rotation_degrees", 22.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(small_cog_right, "rotation_degrees", 67.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(big_cog, "rotation_degrees", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_interval(0.5)
	tween.tween_property(small_cog_bottom, "rotation_degrees", 67.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(small_cog_right, "rotation_degrees", 22.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(big_cog, "rotation_degrees", 90, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_interval(0.5)
	
	if !Game.player:
		await Game.player_spawned
	target = Game.player.get_companion_marker()
		

func _physics_process(delta: float) -> void:
	match state:
		State.FOLLOW:
			_follow(delta)
		State.MOVE:
			_move(delta)


func _follow(delta):
	if !target:
		return
	global_position = lerp(global_position, target.global_position, 0.15)

func _move(delta):
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(move_input * speed, acceleration * delta)
	move_and_slide()
	
	if tween:
		tween.set_speed_scale(1 + 2 * velocity.length() / speed)


func move():
	state = State.MOVE


func follow():
	state = State.FOLLOW
