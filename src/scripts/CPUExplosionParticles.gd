extends CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.4),"timeout")
	queue_free()
