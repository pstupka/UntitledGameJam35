extends KinematicBody2D

export var speed = 150
var _direction = Vector2.ZERO
var _velocity = Vector2.ZERO
var clamp_x_position = 0
var clamp_y_position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("AlleywayPlayer")
	pass


func _physics_process(_delta):
	_velocity = move_and_slide(_direction * speed)
	position.y = clamp_y_position

func _process(_delta):
	_direction = get_direction()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)

