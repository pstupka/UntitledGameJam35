extends KinematicBody2D

var _explosion = preload("res://src/levels/minigames/ExplosionParticles.tscn")
export var _speed = 450
var _direction = Vector2.ZERO
var clamp_x_position = 0
var clamp_y_position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("AlleywayPlayer")

func _physics_process(_delta):
	move_and_slide(_direction * _speed)
	position.y = clamp_y_position

func _process(_delta):
	_direction = get_direction()

func resetSpeed():
	_speed = 450;

func speedUp():
	_speed += 10

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)

func kill():
	spawn_particle()
	queue_free()

func spawn_particle():
	var expl = _explosion.instance()
	expl.emitting = true
	expl.global_position = Vector2(self.position.x, self.position.y)
	get_parent().add_child(expl)
