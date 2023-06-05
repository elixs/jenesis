extends Node2D

@onready var target = $Target
@onready var player = $Player


func _physics_process(delta):
	target.global_position = get_global_mouse_position()

#func _input(event):
#	if event.is_action_pressed("click"):
#		target.global_position = (event as InputEventMouse).position
