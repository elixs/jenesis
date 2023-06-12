extends Node

@export var levels: Array[PackedScene]
@export var credits: PackedScene
var current_level = -1

func next_level():
	if current_level + 1 >= levels.size():
		if credits:
			get_tree().change_scene_to_packed(credits)
		return
	current_level += 1
	get_tree().change_scene_to_packed(levels[current_level])
