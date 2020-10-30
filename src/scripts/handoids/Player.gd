extends KinematicBody2D
var goodLazor = preload("res://src/actors/handoids/Projectile.tscn")

var _speed = 0
var _acc = 0;
var _direction = Vector2.ZERO
var _velocity = Vector2.ZERO
var _rotation = 0
var _bounds = Vector2.ZERO
var _canFire = true;
signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("HandoidsPlayer")
	var timer = Timer.new()
	timer.set_wait_time(0.6)
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()

func setBounds(bounds):
	_bounds = bounds

func destroy():
	emit_signal("destroyed")
	queue_free()
	
func _physics_process(_delta):
	rotation_degrees += _rotation
	_velocity = move_and_slide(_direction * _speed)
	
	# keep the player inside the play area
	if _bounds == Vector2.ZERO:
		pass;
	if (position.x < 0):
		position.x = _bounds.x
	elif (position.x > _bounds.x):
		position.x = 0
	if (position.y < 0):
		position.y = _bounds.y
	elif (position.y > _bounds.y):
		position.y = 0
	
func _process(_delta):
	_speed = getSpeed(_speed);
	_rotation = getRotation();
	_direction = getDirection()

	# Fire handling + throttling	
	if Input.is_action_just_pressed("ui_select") and _canFire:
		spawnProjectile()
		_canFire = false;

func getSpeed(speed):
	var acc = (Input.get_action_strength("move_up") - Input.get_action_strength("move_down")) * 10 
	if acc != 0 and abs(_speed) < 100:
		speed += acc
	elif abs(_speed) < 20:
		speed = 0;
	else:
		speed *= 0.95
	return speed

func getRotation():
	return (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * 4

func getDirection():
	return Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2))

func _on_timer_timeout():
	_canFire = true;
	
func spawnProjectile():
	var lazor = goodLazor.instance();
	lazor.translate(self.position)
	lazor.rotation = rotation
	lazor.moveTowards(_direction)
	get_parent().add_child(lazor)
