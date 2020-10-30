extends StaticBody2D
signal brick_destroyed;

func _on_Area2D_body_exited(body):
	emit_signal("brick_destroyed")
	queue_free()
