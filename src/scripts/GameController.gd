extends Node

enum ARCADE_TYPE {PUNG, ALLEYWAY, INVADOORS, HANDOIDS, PINVADOORS}

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
		ARCADE_TYPE.ALLEYWAY:
			arcade_to_load.load_game("res://src/levels/alleyway/AlleywayGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
		ARCADE_TYPE.INVADOORS:
			arcade_to_load.load_game("res://src/levels/invadoors/InvadoorsGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
		ARCADE_TYPE.HANDOIDS:
			arcade_to_load.load_game("res://src/levels/handoids/HandoidsGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
		ARCADE_TYPE.PINVADOORS:
			arcade_to_load.load_game("res://src/levels/minigames/invadoors/InvadoorsGame.tscn", "res://assets/environment/arcade/arcade_view.png") 
	SceneChanger.transition_to(arcade_to_load)
