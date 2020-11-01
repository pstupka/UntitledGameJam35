extends "res://src/scripts/Game.gd"

var _player = preload("res://src/actors/alleyway/Player.tscn")
var _ball = preload("res://src/actors/alleyway/Ball.tscn")
var _brick = preload("res://src/actors/alleyway/Brick.tscn")

var player
var ball
var bricks = []

onready var score_label = $HUD/ScoreLabel
onready var game_over_label = $HUD/GameOverLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	score_label.set_position(Vector2(bounds_x*0.5 - 24, bounds_y*0.5 - 64))
	score_label.hide()
	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	$Menu/MarginContainer.rect_size = Vector2(bounds_x, bounds_y)
	$HUD/Countdown.set_position(Vector2(bounds_x * 0.5, bounds_y - 75))
	game_over_label.set_position(Vector2(bounds_x*0.5-129, bounds_y*0.1))
	game_over_label.hide()
	
	register_buttons()
	connect("game_over", GameController, "_on_arcade_game_over")
	connect("game_exit", GameController, "_on_arcade_game_exit")

func game_start():
	score = 0
	$HUD/ScoreLabel.text = "%d" % score
	$HUD/ScoreLabel.set_size(Vector2.ZERO)
	
	# add player
	player = _player.instance()
	player.translate(Vector2(10,bounds_y - 10))
	player.clamp_y_position = bounds_y - 10
	add_child(player)
	
	# add bricks
	var bricksX = 4
	var bricksY = 8
	
	for col in range(bricksY):
		for row in range(bricksX):
			var brick = _brick.instance()
			bricks.push_back(brick)
			var offsetX = 75 * row;
			var offsetY = 20 * col
			brick.translate(Vector2( 60 + offsetX, 25 + offsetY ))
			brick.connect("brick_destroyed", self, "on_brick_destroyed")
			add_child(brick)
	start_prepare_phase();

var prepareFlag = false
var prepareCountdown = 3
func _process(delta):
	if !prepareFlag:
		return;
	
	if prepareCountdown < 0:
		prepareFlag = false
		$HUD/Countdown.hide()
		start_game_phase()

	$HUD/Countdown.text = "%d" % ceil(prepareCountdown)
	prepareCountdown -= delta;
	

func start_prepare_phase():
	print("Prepare phase")
	prepareCountdown = 3;
	$HUD/Countdown.show()
	prepareFlag = true;
	pass
	
func start_game_phase():
	# add ball
	ball = _ball.instance()
	ball.translate(Vector2(bounds_x * 0.5, bounds_y * 0.8))
	ball.speed = 200
	add_child(ball)
	
	$HUD/ScoreLabel.show()
	print("AlleywayGame: game start")
	
func game_over():
	# remove actors
	player.kill()
	var i = 0;
	for brick in bricks:
		# don't crash on deleted bricks
		if is_instance_valid(brick):
			brick.kill();
	ball.kill()
	
	$HUD/GameOverLabel.show()
	
	emit_signal("game_over", score, GameController.ARCADE_TYPE.ALLEYWAY)
	var timer = get_tree().create_timer(3.0)
	yield(timer, "timeout")
	
	game_over_label.hide()
	score_label.hide()
	$Menu.show()
	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	print("game_over")

func on_brick_destroyed():
	scored()
	# speed up on each five
	if score % 5 == 0:
		ball.speedUp()
		player.speedUp()
		
func scored():
	score += 1
	score_label.text = "%d" % score	

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("Buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])

func _on_button_pressed(button):
	match button.name:
		"StartButton":
			$Menu.hide()
			game_start()
		"ExitButton":
			emit_signal("game_exit")

func _on_endArea_body_entered(body):
	if (body.is_in_group("Ball")):
		game_over()
