extends StaticBody2D
signal brick_destroyed;
var _explosion = preload("res://src/levels/minigames/ExplosionParticles.tscn")

func _on_Area2D_body_exited(body):
	emit_signal("brick_destroyed")
	kill()

func kill():
	spawn_particle()
	queue_free()

func spawn_particle():
	var expl = _explosion.instance()
	expl.emitting = true
	expl.global_position = Vector2(self.position.x, self.position.y)
	get_parent().add_child(expl)
