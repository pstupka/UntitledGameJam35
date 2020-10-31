extends "res://src/scripts/Game.gd"

var _player_res = preload("res://src/levels/minigames/invadoors/InvadoorsPlayer.tscn")
var player

var _enemy_res = preload("res://src/levels/minigames/invadoors/InvadoorsEnemy.tscn")

onready var score_label = $HUD/ScoreLabel
onready var game_over_label = $HUD/GameOverLabel


func _ready():	
	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	$Menu/MarginContainer.rect_size = Vector2(bounds_x, bounds_y)

	game_over_label.set_position(Vector2(bounds_x*0.5-129, bounds_y*0.1))
	game_over_label.hide()
	
	register_buttons()
	
	connect("game_over", GameController, "_on_arcade_game_over")
	connect("game_exit", GameController, "_on_arcade_game_exit")

func _physics_process(_delta):
	if Input.is_action_just_pressed("arcade_button1"):
		var enemies = get_tree().get_nodes_in_group("InvadoorsEnemy")
		if enemies.size() > 0:
			var tmp_enemy = enemies.pop_back()
			tmp_enemy.kill()

func game_start():
	score = 0
	$HUD/ScoreLabel.text = "score: %d" % 0

	player = _player_res.instance()
	player.clamp_y_position = bounds_y-10
	player.connect("destroyed", self, "_on_player_destroyed")
	add_child(player)

	spawn_enemies()
	
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.start()
	$HUD/ScoreLabel.show()

func game_over():
	# remove the actors
	var enemies = get_tree().get_nodes_in_group("InvadoorsEnemy")
	for enemy in enemies:
		enemy.queue_free()
	player.queue_free();
	$HUD/GameOverLabel.show()
#	score_label.set("custom_colors/font_color", Color(1,1,1))
	
	emit_signal("game_over", score, "InvadoorsGame")
	var timer = get_tree().create_timer(3.0)
	yield(timer, "timeout")
	
	game_over_label.hide()
	score_label.hide()
	$Menu.show()
	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()

func scored():
	score += 10
	score_label.text = "score: %d" % score	

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

func _on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("InvadoorsEnemy")
	for enemy in enemies:
		enemy.tick_down()

func spawn_enemies():
	var enemy
	for i in 9:
		enemy = _enemy_res.instance()
		enemy.translate(Vector2(50 + i*32, 50))
		enemy.scale = Vector2(2,2)
		enemy.connect("killed", self, "scored")
		add_child(enemy)

func _on_player_destroyed():
	game_over()

func _on_LowerBound_body_entered(body):
	if body.is_in_group("InvadoorsEnemy"):
		game_over();
