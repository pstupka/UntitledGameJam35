extends CanvasLayer

onready var _anim_player = $AnimationPlayer

var current_scene = null
var main_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	main_scene = current_scene
	_anim_player.play_backwards("Fade")

func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)

# Kot universal method -- to write it better
func _deferred_goto_scene(scene):
	if (current_scene != main_scene):
		current_scene.free()
	else:
		get_tree().get_root().remove_child(current_scene)
		
	current_scene = scene
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func transition_to(_next_scene):
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	goto_scene(_next_scene)
	_anim_player.play_backwards("Fade")
	yield(_anim_player, "animation_finished")
