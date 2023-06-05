extends Node

@export var levels: Array[PackedScene]

var current_level = 0

func next_level():
	if current_level + 1 >= levels.size():
		return
	current_level += 1
	get_tree().change_scene_to_packed(levels[current_level])
