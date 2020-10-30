extends "res://src/scripts/Game.gd"

var _player = preload("res://src/actors/handoids/Player.tscn")
var _hand = preload("res://src/actors/handoids/Hand.tscn")

var player
var hands = []
var handTimeout = 1;
var handTimer = 0;

onready var score_label = $HUD/ScoreLabel
onready var game_over_label = $HUD/GameOverLabel

var gameInProgress = false

# Called when the node enters the scene tree for the first time.
func _ready():
	score_label.set_position(Vector2(bounds_x*0.5 - 24, bounds_y*0.5 - 64))
	score_label.hide()

	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	$Menu/MarginContainer.rect_size = Vector2(bounds_x, bounds_y)
	

	game_over_label.set_position(Vector2(bounds_x*0.5-129, bounds_y*0.1))
	game_over_label.hide()
	
	register_buttons()
	
	connect("game_over", GameController, "_on_arcade_game_over")
	connect("game_exit", GameController, "_on_arcade_game_exit")

func _process(delta):
	if !gameInProgress:
		handTimer = 0;
	elif handTimer > handTimeout:
		handTimer = 0;
		# spawn a hand
		var alpha = (randi() % 360) * PI / 180
		var hand = _hand.instance()
		hand.translate(Vector2(350 * cos(alpha), 350 * sin(alpha)))
	
		hand.moveToward(Vector2(bounds_x * 0.5, bounds_y * 0.5))
		hand.connect("destroyed", self, "scored")
		hands.push_back(hand)
		add_child(hand)
	else:
		handTimer += delta
		

func game_start():
	gameInProgress = true
	score = 0
	$HUD/ScoreLabel.text = "%d" % score
	$HUD/ScoreLabel.set_size(Vector2.ZERO)
	
	# add player
	player = _player.instance()
	player.connect("destroyed", self, "game_over")
	player.translate(Vector2(bounds_x * 0.5, bounds_y * 0.5))
	player.setBounds(Vector2(bounds_x, bounds_y))
	add_child(player)
			
	$HUD/ScoreLabel.show()
	print("Handoids: game start")

func game_over():
	gameInProgress = false;
	player.queue_free()
	# remove bricks
	var i = 0;
	for hand in hands:
		# don't crash on deleted bricks
		if is_instance_valid(hand):
			hand.queue_free();
		

	$HUD/GameOverLabel.show()
#	score_label.set("custom_colors/font_color", Color(1,1,1))
	
	emit_signal("game_over", score, "PungGame")
	var timer = get_tree().create_timer(3.0)
	yield(timer, "timeout")
	
	game_over_label.hide()
	score_label.hide()
	$Menu.show()
	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	
	print("game_over")

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
	if (body.is_in_group("PungBall")):
		game_over()
