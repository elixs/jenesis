extends GPUParticles2D


func _ready():
	emitting = true
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
