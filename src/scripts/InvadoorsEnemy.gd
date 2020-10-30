extends KinematicBody2D

export var speed = 200
var _velocity = Vector2(-1, -0.1).normalized()
export(PackedScene) var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("InvadoorsEnemy")
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	pass
	
func _on_scoreArea_body_entered(body):
	pass

func tick_down():
	position.y = position.y + 8

func kill():
	var expl = explosion.instance()
	expl.emitting = true
	expl.global_position = Vector2(self.position.x, self.position.y)
	get_parent().add_child(expl)
	queue_free()
