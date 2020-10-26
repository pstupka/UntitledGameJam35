extends Node2D

signal game_start
signal game_stop
signal game_pause
signal game_exit

var bounds_x = 350
var bounds_y = 300
var screen_offset = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_translate = Vector2(
		OS.get_window_size().x/2-bounds_x/2,
		(OS.get_window_size().y-bounds_y+screen_offset.y)/2)
	translate(screen_translate)

#	debug color rectangle
#	var crect = ColorRect.new()
#	crect.set_size(Vector2(bounds_x,bounds_y))
#	crect.color = Color.blue
#	add_child(crect)
	
	print("Game ready")


func start_game():
	emit_signal("game_start")
	print("Game: Game start")
	pass


func end_game():
	emit_signal("game_exit")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
