extends "res://src/scripts/Game.gd"

var _player = preload("res://src/actors/PungPlayer.tscn")
var _player2 = preload("res://src/actors/PungPlayer.tscn")
var _pungball = preload("res://src/actors/PungBall.tscn")

var player
var player2
var pungball

# Called when the node enters the scene tree for the first time.
func _ready():
	$Wall1.translate(Vector2(bounds_x*0.5, 0))
	$Wall2.translate(Vector2(bounds_x*0.5, bounds_y))
	
	$HUD/ScoreLabel.set_position(Vector2(bounds_x*0.5 - 24, bounds_y*0.5 - 64))
	$HUD/ScoreLabel.hide()

	$Menu/MarginContainer/ColorRect/VBoxContainer/StartButton.grab_focus()
	$Menu/MarginContainer.rect_size = Vector2(bounds_x, bounds_y)

	$EndArea.translate((Vector2(-5,bounds_y*0.5)))
	$EndArea2.translate((Vector2(bounds_x+5,bounds_y*0.5)))

	$HUD/GameOverLabel.set_position(Vector2(bounds_x*0.5-129, bounds_y*0.1))
	$HUD/GameOverLabel.hide()

	register_buttons()
	
	print("Game pung ready")


func game_start():
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
	
	$Timer.start()
	print("PungGame: game start")


func _on_Timer_timeout():
	score += 1
	$HUD/ScoreLabel.text = "%d" % score	


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
			print("Exit pressed")


func _on_EndArea_body_entered(body):
	if (body.is_in_group("PungBall")):
		$Timer.stop()
		player.queue_free()
		player2.queue_free()
		pungball.queue_free()
		$HUD/GameOverLabel.show()
		$HUD/ScoreLabel.set("custom_colors/font_color", Color(1,1,1))
		emit_signal("game_exit", score)
