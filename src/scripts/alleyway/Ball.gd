extends KinematicBody2D

export var speed = 200
var _direction = Vector2(-1, -0.1).normalized()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Ball")
	# we want the ball to move within -150 : -30 deg
	randomize()
	var rand = ((randi() % 180) - 30) * -1
	var angle = rand * PI / 180
	_direction = Vector2(cos(angle), sin(angle))

func _physics_process(delta):
	var collision = move_and_collide(_direction * speed * delta)
	if collision:
		_direction = _direction.bounce(collision.normal)
		# move away a bit from the collision point
		move_and_slide(_direction * 2)

func speedUp():
	speed += 10
