extends Node2D


export (PackedScene) var game_scene
var _game_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	var _game_scene = game_scene.instance()
	
	add_child(_game_scene)
	_game_scene.game_start()
	



