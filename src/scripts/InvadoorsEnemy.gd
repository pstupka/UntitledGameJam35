extends KinematicBody2D
var bullet_res = preload("res://src/levels/minigames/invadoors/Bullet.tscn")
var _explosion = preload("res://src/levels/minigames/ExplosionParticles.tscn")
signal killed

export var speed = 200
var _shootCounter = 4; #[s]
var _velocity = Vector2(-1, -0.1).normalized()
export(PackedScene) var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("InvadoorsEnemy")
	$AnimationPlayer.play("idle")
	_shootCounter = get_shoot_counter()
	
func _physics_process(delta):
	pass

func _process(delta):
	if _shootCounter >= 0:
		_shootCounter -= delta
	else:
		shoot();
		_shootCounter = get_shoot_counter()
		
func get_shoot_counter():
	randomize();
	return (randf() * 3.0) + 2;

func tick_down():
	position.y = position.y + 8

func kill():
	emit_signal("killed")
	terminate()

func terminate():
	var expl = explosion.instance()
	expl.emitting = true
	expl.global_position = Vector2(self.position.x, self.position.y)
	get_parent().add_child(expl)
	queue_free()

func shoot():
	var bullet = bullet_res.instance()
	bullet.translate(Vector2(self.position.x, self.position.y + 10))
	bullet.set_direction(Vector2.DOWN)
	bullet.set_target("InvadoorsPlayer")
	get_parent().add_child(bullet)
