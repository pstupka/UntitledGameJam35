extends KinematicBody2D

export var speed = 150
var _direction = Vector2.ZERO
var _velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("PungPlayer")
	pass


func _physics_process(_delta):
	_velocity = move_and_slide(_direction * speed)
	position.x = clamp(position.x, 0, get_parent().bounds_x)
	position.y = clamp(position.y, 0, get_parent().bounds_y-$Sprite.texture.get_size().y)

func _process(_delta):
	_direction = get_direction()

func get_direction() -> Vector2:
	return Vector2(
		0,
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

