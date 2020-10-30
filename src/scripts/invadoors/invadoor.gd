extends KinematicBody2D
var _badLazor = preload("res://src/actors/invadoors/BadLazor.tscn")

signal destroyed

func destroy():
	emit_signal("destroyed")
	queue_free()

# Called when the node enters the scene tree for the first time.
var shootInterval = 0;
func _ready():
	shootInterval = (randi() % 80) / 10 + 1.5;

var shootTimer = 0;
var moveTimer = 0;
var moveInterval = 1.5;
var moveDir = -10

func _process(delta):
	shootTimer += delta;
	moveTimer += delta;

	# Shooting
	if shootTimer >= shootInterval:
		# reset the "timer"
		shootInterval = (randi() % 80) / 10 + 1.5;
		shootTimer = 0;
		# spawn lazor
		var lazor = _badLazor.instance();
		lazor.translate(self.position)
		get_parent().add_child(lazor)
		
	# Moving	
	if moveTimer >= moveInterval:
		# reset the "timer"
		moveTimer = 0;
		position.x += moveDir
		if moveDir == -10:
			moveDir = 10;
		else:
			moveDir = -10;
