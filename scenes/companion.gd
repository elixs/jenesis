extends Node2D

@onready var small_cog_right = $SmallCogRight
@onready var small_cog_bottom = $SmallCogBottom
@onready var big_cog = $BigCog


func _ready():
	var tween_scb = create_tween()
	tween_scb.set_loops()
	tween_scb.tween_property(small_cog_bottom, "rotation_degrees", 22.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_scb.tween_interval(0.5)
	tween_scb.tween_property(small_cog_bottom, "rotation_degrees", 67.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_scb.tween_interval(0.5)
	var tween_scr = create_tween()
	tween_scr.set_loops()
	tween_scr.tween_property(small_cog_right, "rotation_degrees", 67.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_scr.tween_interval(0.5)
	tween_scr.tween_property(small_cog_right, "rotation_degrees", 22.5, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_scr.tween_interval(0.5)
	
	var tween_bc = create_tween()
	tween_bc.set_loops()
	tween_bc.tween_property(big_cog, "rotation_degrees", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_bc.tween_interval(0.5)
	tween_bc.tween_property(big_cog, "rotation_degrees", 90, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_bc.tween_interval(0.5)
	
