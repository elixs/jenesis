class_name CameraWithShake
extends Camera2D

@export var distance: float = 5
@export var points: int = 5
@export var duration: float = 0.2

@export var target: Node2D


var _zoom_enabled := false


func _ready() -> void:
	Game.camera = self

func shake() -> void:
	var tween = create_tween()
	var delta = duration / points
	for i in points:
		var random_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * distance
		tween.tween_property(self, "offset", random_position, delta)
	tween.tween_property(self, "offset", Vector2.ZERO, 0)
	
func change_parent(parent: Node2D) -> void:
	var current_position = global_position
	print(global_position)
	get_parent().remove_child(self)
	parent.add_child(self)
	print(global_position)
	position = current_position - global_position

func _physics_process(delta: float) -> void:
	if target:
		global_position = target.global_position
	
	if _zoom_enabled:
		if Input.is_action_pressed("zoom_up_key"):
			zoom += Vector2.ONE * 0.01
		if Input.is_action_pressed("zoom_down_key"):
			zoom -= Vector2.ONE * 0.01
	


func _input(event: InputEvent) -> void:
	if _zoom_enabled:
		if event.is_action_pressed("zoom_up"):
			zoom += Vector2.ONE * 0.1
		if event.is_action_pressed("zoom_down"):
			zoom -= Vector2.ONE * 0.1


func enable_zoom(enable: bool) -> void:
	_zoom_enabled = enable
	zoom = Vector2.ONE


func set_smoothing_speed(value):
	position_smoothing_speed = value
	process_callback = Camera2D.CAMERA2D_PROCESS_IDLE
	await get_tree().process_frame
	process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
