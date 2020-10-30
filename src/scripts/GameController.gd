extends Node

<<<<<<< HEAD
enum ARCADE_TYPE {PUNG, ALLEYWAY, INVADOORS, HANDOIDS}
>>>>>>> 9691b93ca3e3bdd6c0a9f389de783de2a43407e5

func _on_arcade_game_over(score, name):
	print("Score ", score)
	print("Name ", name)

func _on_arcade_game_exit():
	SceneChanger.transition_to(SceneChanger.main_scene)

func load_arcade_control(game):
	var arcade_to_load = ResourceLoader.load("res://src/levels/ArcadeControl.tscn").instance()
	match game:
		ARCADE_TYPE.PUNG:
<<<<<<< HEAD
			arcade_to_load = ResourceLoader.load("res://src/levels/ArcadeControl.tscn").instance()
			arcade_to_load.load_game("res://src/levels/pung/PungGame.tscn", "res://assets/environment/arcade/arcade_pong.png") 
			SceneChanger.transition_to(arcade_to_load)
		ARCADE_TYPE.ALLEYWAY:
			arcade_to_load = ResourceLoader.load("res://src/levels/ArcadeControl.tscn").instance()
			arcade_to_load.load_game("res://src/levels/alleyway/AlleyWayGame.tscn", "res://assets/environment/arcade/arcade_pong.png") 
			SceneChanger.transition_to(arcade_to_load)
		ARCADE_TYPE.INVADOORS:
			arcade_to_load = ResourceLoader.load("res://src/levels/ArcadeControl.tscn").instance()
			arcade_to_load.load_game("res://src/levels/invadoors/InvadoorsGame.tscn", "res://assets/environment/arcade/arcade_pong.png") 
			SceneChanger.transition_to(arcade_to_load)
		ARCADE_TYPE.HANDOIDS:
			arcade_to_load = ResourceLoader.load("res://src/levels/ArcadeControl.tscn").instance()
			arcade_to_load.load_game("res://src/levels/handoids/handoidsgame.tscn", "res://assets/environment/arcade/arcade_pong.png") 
			SceneChanger.transition_to(arcade_to_load)
>>>>>>> 9691b93ca3e3bdd6c0a9f389de783de2a43407e5
	
