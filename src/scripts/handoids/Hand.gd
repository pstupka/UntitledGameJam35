extends Area2D

var _explosion = preload("res://src/levels/minigames/CPUExplosionParticles.tscn")
signal destroyed;

var life = 2;
var dir = Vector2.ZERO
var _speed = 1

func _ready():
	add_to_group("HandoidsHands")

func applyDamage():
	if life == 2:
		$Crack.visible = true;
	elif life == 1:
		$Crack.visible = false;
		$Crack2.visible = true;
	else:
		emit_signal("destroyed")
		kill()
	life -= 1

func moveToward(_dir):
	dir = (position - _dir).normalized()
	rotation = atan2(position.y - _dir.y, position.x - _dir.x) - PI / 2 

func _process(delta):
	if dir == Vector2.ZERO:
		pass;
	position -= dir * _speed

func set_speed(speed):
	_speed = speed

# this should be responsible for the player being hit
func _on_Area2D_body_entered(body):
	if body.is_in_group("HandoidsPlayer"):
		body.destroy()

func _on_Area2D_area_entered(area):
	if area.is_in_group("HandoidsHands"):
		pass;
	elif area.is_in_group("HandoidsProjectile"):
		applyDamage()
		area.queue_free()

func kill():
	spawn_explosion()
	queue_free()

func spawn_explosion():
	var expl = _explosion.instance()
	expl.emitting = true
	expl.global_position = Vector2(self.position.x, self.position.y)
	get_parent().add_child(expl)
