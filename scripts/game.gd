extends Node


signal player_spawned

var player: Player
var camera: CameraWithShake

var jumps = 0
var bullet = false

var language = "en"

func shake_camera():
	if camera:
		camera.shake()
