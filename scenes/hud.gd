extends MarginContainer

@onready var progress_bar = $ProgressBar
@onready var kills = $Kills



func set_health(value):
	progress_bar.value = value


func set_kills(value):
	kills.text = str(value)
	
