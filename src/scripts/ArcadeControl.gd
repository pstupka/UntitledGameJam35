extends Node2D


export (PackedScene) var game_scene
var _game_scene
var joy_direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	var _game_scene = game_scene.instance()
	
	add_child(_game_scene)
	var screen_translate = Vector2(
		(OS.get_window_size().x-_game_scene.bounds_x)*0.5,
		120)

	_game_scene.translate(screen_translate)
	
	_game_scene.connect("game_exit", self, "_on_game_exit")


func _process(_delta):
	handle_joystick_direction()
	handle_button_pressed()


#	Change code to trigger discrete values when using analog
func handle_joystick_direction() :
	joy_direction = Vector2(
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	$ArcadeControls/Joystick.region_rect = Rect2(32 + joy_direction.y*32,
							32 + joy_direction.x*32, 
							32,
							32)


func handle_button_pressed():
	if Input.is_action_pressed("arcade_button1") or Input.is_action_pressed("ui_select"):
		$ArcadeControls/Button1.region_rect = Rect2(8, 0, 8, 8)
	else:
		$ArcadeControls/Button1.region_rect = Rect2(0, 0, 8, 8)
		
	if Input.is_action_pressed("arcade_button2"):
		$ArcadeControls/Button2.region_rect = Rect2(24, 0, 8, 8)
	else:
		$ArcadeControls/Button2.region_rect = Rect2(16, 0, 8, 8)
		
	if Input.is_action_pressed("arcade_button3"):
		$ArcadeControls/Button3.region_rect = Rect2(40, 0, 8, 8)
	else:
		$ArcadeControls/Button3.region_rect = Rect2(32, 0, 8, 8)
		
	if Input.is_action_pressed("arcade_button4"):
		$ArcadeControls/Button4.region_rect = Rect2(56, 0, 8, 8)
	else:
		$ArcadeControls/Button4.region_rect = Rect2(48, 0, 8, 8)


func _on_game_exit(score):
	print(score)

