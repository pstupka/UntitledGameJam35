extends Area2D

func _process(delta):
	position.y -= 1.5
	if position.y < -10:
		queue_free()

func _on_Area2D_body_entered(body):
	body.destroy()
	queue_free();
