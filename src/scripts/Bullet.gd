extends Area2D

var speed = -350
var targetGroup = "InvadoorsEnemy"

func _physics_process(delta):
	position.y +=  speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group(targetGroup):
		body.kill()
		queue_free()

func set_direction(dir):
	if dir == Vector2.DOWN:
		speed = 350
	elif dir == Vector2.UP:
		speed = -350
		
func set_target(group):
	targetGroup = group
