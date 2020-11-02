extends KinematicBody2D

var _explosion = preload("res://src/levels/minigames/CPUExplosionParticles.tscn")
var bullet_res = preload("res://src/levels/minigames/invadoors/Bullet.tscn")
export var speed = 200
var _direction = Vector2.ZERO
var _velocity = Vector2.ZERO
var clamp_y_position = 0

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("InvadoorsPlayer")

func _physics_process(_delta):
	_velocity = move_and_slide(_direction * speed)
	position.x = clamp(position.x, 10, 340)
	position.y = clamp_y_position

func _process(_delta):
	_direction = get_direction()
	if Input.is_action_just_pressed("arcade_button1") or Input.is_action_just_pressed("interact"):
		shoot()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0)

func kill():
	emit_signal("destroyed")


func shoot():
	var bullet = bullet_res.instance()
	bullet.translate(Vector2(self.position.x, self.position.y-5))
	get_parent().add_child(bullet)

func terminate():
	var expl = _explosion.instance()
	expl.emitting = true
	expl.global_position = Vector2(self.position.x, self.position.y)
	get_parent().add_child(expl)
	queue_free()
