extends Area2D

var speed = -350

func _physics_process(delta):
	position.y +=  speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("InvadoorsEnemy"):
		body.kill()
	queue_free()
