extends Area2D


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(player: Player):
	if player:
		LevelManager.next_level()
