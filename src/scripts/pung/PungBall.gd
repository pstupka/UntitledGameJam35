extends KinematicBody2D

export var speed = 250
var _velocity = Vector2(-1, -0.1).normalized()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("PungBall")
	pass


func _physics_process(delta):
	var collision = move_and_collide(_velocity * speed * delta)
	if collision:
		_velocity = _velocity.bounce(collision.normal)

