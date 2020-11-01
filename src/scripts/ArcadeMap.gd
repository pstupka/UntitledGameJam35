extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _gameArea = null
var _scoreboard

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("interact", self, "_on_player_interaction")
	prepare_scoreboard();
	
func restore_player_position(pos):
	$Player.position = pos

func _on_player_interaction():
	if _gameArea == null:
		return
	GameController.keep_player_position($Player.position)
	GameController.load_arcade_control(_gameArea)


func _on_PongArea_body_entered(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = GameController.ARCADE_TYPE.PUNG

func _on_PongArea_body_exited(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = null

func _on_InvadoorsArea_body_entered(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = GameController.ARCADE_TYPE.PINVADOORS

func _on_InvadoorsArea_body_exited(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = null

func _on_HandoidsArea_body_entered(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = GameController.ARCADE_TYPE.HANDOIDS

func _on_HandoidsArea_body_exited(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = null

func _on_AlleywayArea_body_entered(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = GameController.ARCADE_TYPE.ALLEYWAY

func _on_AlleywayArea_body_exited(body):
	if body.is_in_group("MainPlayer"):
		_gameArea = null

func prepare_scoreboard():
	_scoreboard = GameController._get_scoreboard()
	# pls bez komentarza
	$ScoreBoard/Games.text =  "Alleyway\nInvadoors\nPung\nHandoids"
	$ScoreBoard/Score.text =  " score: %d" % _scoreboard[GameController.ARCADE_TYPE.ALLEYWAY] + "\n";
	$ScoreBoard/Score.text += " score: %d" % _scoreboard[GameController.ARCADE_TYPE.PINVADOORS] + "\n";
	$ScoreBoard/Score.text += " score: %d" % _scoreboard[GameController.ARCADE_TYPE.PUNG] + "\n";
	$ScoreBoard/Score.text += " score: %d" % _scoreboard[GameController.ARCADE_TYPE.HANDOIDS];
	
func _on_ScoreboardArea_body_entered(body):
	if body.is_in_group("MainPlayer"):
		$ScoreBoard.visible = true

func _on_ScoreboardArea_body_exited(body):
	if body.is_in_group("MainPlayer"):
		$ScoreBoard.visible = false
