extends KinematicBody2D

export var speed = 200
var _velocity = Vector2(-1, -0.1).normalized()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("PungBall")
	randomize()
	_velocity = Vector2(2*randf()-1,0.5*randf()-0.25).normalized()
	pass


func _physics_process(delta):
	var collision = move_and_collide(_velocity * speed * delta)
	if collision:
		_velocity = _velocity.bounce(collision.normal) + collision.collider_velocity.normalized()*0.2



func _on_scoreArea_body_entered(body):
	if body.is_in_group("PungPlayer"):
		get_parent().scored() 
