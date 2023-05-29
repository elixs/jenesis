class_name CameraWithShake
extends Node2D

@export var distance: float = 5
@export var points: int = 5
@export var duration: float = 0.2
@export var enabled: bool = true

@onready var camera_2d = $Camera2D

func _ready():
	camera_2d.enabled = enabled

func shake() -> void:
	var tween = create_tween()
	var delta = duration / points
	for i in points:
		var random_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * distance
		tween.tween_property(camera_2d, "position", random_position, delta)
	tween.tween_property(camera_2d, "position", Vector2.ZERO, 0)
	
