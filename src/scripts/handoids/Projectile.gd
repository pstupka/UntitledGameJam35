extends Area2D
const speed = 3
var dir = Vector2.ZERO

func _ready():
	add_to_group("HandoidsProjectile")

func moveTowards(_dir):
	dir = _dir;
	
func _process(delta):
	if dir == Vector2.ZERO:
		pass;
	position.x += speed * dir.x
	position.y += speed * dir.y
	
	# SUPER UGLY BOUNDS
	if position.y < -10 or position.y > 400 or position.x < -10 or position.x > 400:
		queue_free()
