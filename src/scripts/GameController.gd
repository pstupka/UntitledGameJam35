extends Node

enum ARCADE_TYPE {PUNG, ALLEYWAY, INVADOORS, HANDOIDS, PINVADOORS}
var _arcademap = preload("res://src/levels/ArcadeMap.tscn")
var arcadeMap
var _playerPosition

var _scoreboard = {	ARCADE_TYPE.PUNG: 0,
					ARCADE_TYPE.ALLEYWAY: 0, 
					ARCADE_TYPE.HANDOIDS: 0, 
					ARCADE_TYPE.PINVADOORS: 0}

func keep_player_position(pos):
	_playerPosition = pos

func _ready():
	arcadeMap = _arcademap.instance()
	load_score()

func _on_arcade_game_over(score, name):
	if _scoreboard[name] < score:
		_scoreboard[name] = score;
		save_score()
	
	print("Score ", score)
	print("Name ", name)

func _get_scoreboard():
	return _scoreboard

func _on_arcade_game_exit():
	var arcademap = _arcademap.instance()
	SceneChanger.transition_to(arcademap)
	arcademap.restore_player_position(_playerPosition);

func enter_arcade():
	SceneChanger.transition_to(_arcademap.instance())

func load_arcade_control(game):
	var arcade_to_load = ResourceLoader.load("res://src/levels/ArcadeControl.tscn").instance()
	match game:
		ARCADE_TYPE.PUNG:
			arcade_to_load.load_game("res://src/levels/minigames/pung/PungGame.tscn", "res://assets/environment/arcade/arcade_pong.png") 
		ARCADE_TYPE.ALLEYWAY:
			arcade_to_load.load_game("res://src/levels/alleyway/AlleywayGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
		ARCADE_TYPE.INVADOORS:
			arcade_to_load.load_game("res://src/levels/invadoors/InvadoorsGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
		ARCADE_TYPE.HANDOIDS:
			arcade_to_load.load_game("res://src/levels/handoids/HandoidsGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
		ARCADE_TYPE.PINVADOORS:
			arcade_to_load.load_game("res://src/levels/minigames/invadoors/InvadoorsGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
	SceneChanger.transition_to(arcade_to_load)


# SHOULD STORE A JSON, BUT NO TIME
const savepath = "user://untitledgamejam.save"
func save_score():
	var save_game = File.new()
	save_game.open(savepath, File.WRITE)
	for game in _scoreboard:
		save_game.store_line("%d" % _scoreboard[game])
	save_game.close()

func load_score():
	var save_game = File.new()
	if not save_game.file_exists(savepath):
		print("No saved file")
		return		
	save_game.open(savepath, File.READ)
	for game in _scoreboard:
		if save_game.get_position() < save_game.get_len():
		 _scoreboard[game] = int(save_game.get_line())
	save_game.close()

func reset_score():
	for game in _scoreboard:
		_scoreboard[game] = 0
	save_score()
