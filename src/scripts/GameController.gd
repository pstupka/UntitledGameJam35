extends Node

enum ARCADE_TYPE {PUNG, INVADOORS}

func _on_arcade_game_over(score, name):
	print("Score ", score)
	print("Name ", name)

func _on_arcade_game_exit():
	SceneChanger.transition_to(SceneChanger.main_scene)

func load_arcade_control(game):
	var arcade_to_load = ResourceLoader.load("res://src/levels/ArcadeControl.tscn").instance()
	match game:
		ARCADE_TYPE.PUNG:
			arcade_to_load.load_game("res://src/levels/minigames/pung/PungGame.tscn", "res://assets/environment/arcade/arcade_pong.png") 
		ARCADE_TYPE.INVADOORS:
			arcade_to_load.load_game("res://src/levels/minigames/invadoors/InvadoorsGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
	SceneChanger.transition_to(arcade_to_load)
	
