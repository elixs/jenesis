class_name CameraWithShake
extends Camera2D

@export var distance: float = 5
@export var points: int = 5
@export var duration: float = 0.2


func shake() -> void:
	var tween = create_tween()
	var delta = duration / points
	for i in points:
		var random_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * distance
		tween.tween_property(self, "offset", random_position, delta)
	tween.tween_property(self, "offset", Vector2.ZERO, 0)
	
