extends "res://src/scripts/Game.gd"

var _player = preload("res://src/actors/invadoors/Player.tscn")
var _invadoor = preload("res://src/actors/invadoors/invadoor.tscn")

var player
var invadoors = []

onready var score_label = $HUD/ScoreLabel
onready var game_over_label = $HUD/GameOverLabel

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

func game_start():
	score = 0
	$HUD/ScoreLabel.text = "%d" % score
	$HUD/ScoreLabel.set_size(Vector2.ZERO)
	
	# add player
	player = _player.instance()
	player.connect("destroyed", self, "game_over")
	player.translate(Vector2(10,bounds_y - 10))
	player.clamp_y_position = bounds_y - 10
	add_child(player)
		
	var invadoors_X = 4;
	var invadoors_Y = 4;
	for col in range(invadoors_X):
		for row in range(invadoors_Y):
			var invadoor = _invadoor.instance();
			invadoors.push_back(invadoor)
			var offsetX = 75 * row + 60;
			var offsetY = 50 * col + 25
			if col % 2 == 0:
				offsetX -= 30
			invadoor.translate(Vector2( offsetX,  offsetY ))
			invadoor.connect("destroyed", self, "scored")
			add_child(invadoor)
	$HUD/ScoreLabel.show()
	print("AlleywayGame: game start")

func game_over():
	player.queue_free()
	# remove bricks
	var i = 0;
	for invader in invadoors:
		# don't crash on deleted bricks
		if is_instance_valid(invader):
			invader.queue_free();
		

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
