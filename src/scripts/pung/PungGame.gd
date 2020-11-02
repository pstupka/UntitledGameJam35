extends "res://src/scripts/Game.gd"

var _player = preload("res://src/actors/PungPlayer.tscn")
var _player2 = preload("res://src/actors/PungPlayer.tscn")
var _pungball = preload("res://src/actors/PungBall.tscn")

var player
var player2
var pungball


onready var score_label = $HUD/ScoreLabel
onready var game_over_label = $HUD/GameOverLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Wall1.translate(Vector2(bounds_x*0.5, 0))
	$Wall2.translate(Vector2(bounds_x*0.5, bounds_y))
	
	score_label.set_position(Vector2(bounds_x*0.5 - 24, bounds_y*0.5 - 64))
	score_label.hide()

	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	$Menu/MarginContainer.rect_size = Vector2(bounds_x, bounds_y)

	$EndArea.translate((Vector2(-5,bounds_y*0.5)))
	$EndArea2.translate((Vector2(bounds_x+5,bounds_y*0.5)))

	game_over_label.set_position(Vector2(bounds_x*0.5-129, bounds_y*0.1))
	game_over_label.hide()
	
	register_buttons()
	
	connect("game_over", GameController, "_on_arcade_game_over")
	connect("game_exit", GameController, "_on_arcade_game_exit")
	
	print("Game pung ready")

func game_start():
	score = 0
	$HUD/ScoreLabel.text = "%d" % 0
	$HUD/ScoreLabel.set_size(Vector2.ZERO)
	
	player = _player.instance()
	player.translate(Vector2(10,bounds_y*0.5))
	player.clamp_x_position = 10
	add_child(player)
	
	player2 = _player2.instance()
	player2.translate(Vector2(bounds_x-10,bounds_y*0.5))
	player2.clamp_x_position = bounds_x-10
	add_child(player2)
	
	pungball = _pungball.instance()
	pungball.translate(Vector2(bounds_x*0.5, bounds_y*0.5))
	add_child(pungball)

	$HUD/ScoreLabel.show()
	
	print("PungGame: game start")

func game_over():
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(player2):
		player2.queue_free()
	if is_instance_valid(pungball):
		pungball.queue_free()
	$HUD/GameOverLabel.show()
#	score_label.set("custom_colors/font_color", Color(1,1,1))
	
	emit_signal("game_over", score, GameController.ARCADE_TYPE.PUNG)
	var timer = get_tree().create_timer(3.0)
	yield(timer, "timeout")
	
	game_over_label.hide()
	score_label.hide()
	$Menu.show()
	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	print("game_over")

func _process(delta):
	if Input.is_action_just_pressed("arcade_button2"):
		game_over()

func scored():
	score += 1
	score_label.text = "%d" % score	
	if score % 3 == 0:
		player.speedUp()
		player2.speedUp()
		pungball.speedUp()
		
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

