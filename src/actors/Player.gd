extends KinematicBody2D


onready var animationPlayer = $Animation 


enum STATES {IDLE, RUN, SMASH, INTERACT}
var state = STATES.IDLE

export var speed = 80
var _direction = Vector2.ZERO
var _velocity = Vector2.ZERO

var is_interacting = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(_delta):
	_velocity = move_and_slide(_direction * speed)


func _process(_delta):
	_direction = get_direction()
	
	if (_direction.x != 0 or _direction.y != 0):
		state = STATES.RUN
	else:
		state = STATES.IDLE
	
	if _direction.x > 0:
		$Sprite.flip_h = false
		$Sprite2.flip_h = false
		$Sprite3.flip_h = false
	elif _direction.x < 0:
		$Sprite.flip_h = true
		$Sprite2.flip_h = true
		$Sprite3.flip_h = true
	
	if Input.is_action_just_pressed("interact") and is_interacting == 0:
		GameController.load_arcade_control(GameController.ARCADE_TYPE.HANDOIDS)
		is_interacting = 20
	if is_interacting > 0:
		is_interacting -= 1

	
	match state:
		STATES.IDLE:
			animationPlayer.play("Idle")
		STATES.RUN:
			animationPlayer.play("Run")


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
