extends MarginContainer

@onready var resume = %Resume
@onready var retry = %Retry
@onready var exit = %Exit

func _ready():
	resume.pressed.connect(_on_resume_pressed)
	retry.pressed.connect(_on_retry_pressed)
	exit.pressed.connect(_on_exit_pressed)
	hide()


func _input(event):
	if event.is_action_pressed("pause"):
		show()
		get_tree().paused = true

func _on_resume_pressed():
	hide()
	get_tree().paused = false


func _on_retry_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false	


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
	get_tree().paused = false
