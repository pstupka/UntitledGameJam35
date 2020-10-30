extends KinematicBody2D
var goodLazor = preload("res://src/actors/invadoors/GoodLazor.tscn")

export var speed = 150
var _direction = Vector2.ZERO
var _velocity = Vector2.ZERO
var clamp_y_position = 0
var _bounds = Vector2.ZERO
var _canFire = true

signal destroyed

func _ready():
	add_to_group("InvadoorsPlayer")
	var timer = Timer.new()
	timer.set_wait_time(0.6)
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()

func destroy():
	emit_signal("destroyed")
	queue_free()
	
func setBounds(bounds):
	_bounds = bounds
	
func _physics_process(_delta):
	_velocity = move_and_slide(_direction * speed)
	position.y = clamp_y_position
	
	# keep the player in the play area
	if _bounds == Vector2.ZERO:
		pass
	elif (position.x < 0):
		position.x = _bounds.x;
	elif (position.x > _bounds.x):
		position.x = 0;

func _process(_delta):
	_direction = get_direction()
	if Input.is_action_just_pressed("ui_select") and _canFire:
		var lazor = goodLazor.instance();
		lazor.translate(self.position)
		get_parent().add_child(lazor)
		
func _on_timer_timeout():
	_canFire = true
	
func get_direction() -> Vector2:
	return Vector2(
		(Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * 2,
		0
	)
