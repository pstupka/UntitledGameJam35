extends RigidBody2D

var _projectile = preload("res://src/actors/handoids/Projectile.tscn")
var _explosion = preload("res://src/levels/minigames/CPUExplosionParticles.tscn")

var _speed = 0
var _acc = 0;
var _direction = Vector2.ZERO
var _velocity = Vector2.ZERO
var _rotation = 0
var _bounds = Vector2.ZERO
var _canFire = 0;
signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("HandoidsPlayer")

func setBounds(bounds):
	_bounds = bounds

func destroy():
	emit_signal("destroyed")
	queue_free()
	

var newPos = Vector2.ZERO

func _process(delta):
		# Fire handling + throttling	
	if Input.is_action_just_pressed("ui_select") and _canFire <= 0:
		spawnProjectile()
		_canFire = 10;
	if _canFire > 0:
		_canFire -= 1;
		
var thrust = Vector2(0, 75)
var torque = 1500
const tpOffset = 10
onready var parent = get_parent()

func _integrate_forces(state):
	# thrust
	if linear_velocity.length() < 75:
		if Input.is_action_pressed("move_up"):
			applied_force = thrust.rotated(rotation + PI)
		elif Input.is_action_pressed("move_down"):
			applied_force = thrust.rotated(rotation)
	else:
		applied_force = Vector2.ZERO
	
	# rotation
	var rotation_dir = 0
	if abs(angular_velocity) < 8:
		if Input.is_action_pressed("move_right"):
			rotation_dir += 1
		if Input.is_action_pressed("move_left"):
			rotation_dir -= 1
	applied_torque = rotation_dir * torque
	
	#  teleport. state.transform.origin is not working ??
	if _bounds == Vector2.ZERO:
		return;

	var sForm = state.get_transform()
	var localpos = parent.to_local(sForm.origin)
	if localpos.x > _bounds.x:
		sForm.origin = parent.to_global(Vector2(10, position.y))
		state.set_transform(sForm)
	if localpos.x < 0:
		sForm.origin = parent.to_global(Vector2(_bounds.x - 10, position.y))
		state.set_transform(sForm)
	if localpos.y > _bounds.y:
		sForm.origin = parent.to_global(Vector2(position.x, 10))
		state.set_transform(sForm)
	if localpos.y < 0:
		sForm.origin = parent.to_global(Vector2(position.x, _bounds.y - 10))
		state.set_transform(sForm)
		
func getDirection():
	return Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2))
	
func spawnProjectile():
	var projectile = _projectile.instance();
	projectile.translate(self.position)
	projectile.rotation = rotation
	projectile.moveTowards(getDirection())
	get_parent().add_child(projectile)

func kill():
	spawn_explosion();
	queue_free()

func spawn_explosion():
	var expl = _explosion.instance()
	expl.emitting = true
	expl.global_position = Vector2(self.position.x, self.position.y)
	get_parent().add_child(expl)
