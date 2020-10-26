extends "res://src/scripts/Game.gd"

onready var player = $PungPlayer
onready var player2 = $PungPlayer2

# Called when the node enters the scene tree for the first time.
func _ready():
	player.translate(Vector2(10,bounds_y/2))
	player2.translate(Vector2(bounds_x-10,bounds_y/2))
	print("Game pung ready")


func game_start():
	print("PungGame: game start")
