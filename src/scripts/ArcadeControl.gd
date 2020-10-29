extends Node2D

var joy_direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Arcades")
	print("arcade created")

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

func load_game(path, sprite_path):
	var game_scene = ResourceLoader.load(path).instance()
	var sprite = ResourceLoader.load(sprite_path)
	$ArcadeSprite.texture = sprite
	
	var screen_translate = Vector2(
		(OS.get_window_size().x-game_scene.bounds_x)*0.5,
		120)

	game_scene.translate(screen_translate)

	add_child(game_scene)
