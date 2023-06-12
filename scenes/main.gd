extends Node2D
@onready var player: Player = $Player
@onready var camera: CameraWithShake = $CameraWithShake
@onready var companion: Node2D = $Companion

func _ready() -> void:
	player.companion_toggled.connect(_toggle_companion)


func _toggle_companion(toggle: bool) -> void:
	if toggle:
		camera.target = companion
		camera.enable_zoom(true)
		camera.set_smoothing_speed(10)
		companion.move()
	else:
		camera.target = player
		camera.enable_zoom(false)
		camera.set_smoothing_speed(5)
		companion.follow()
