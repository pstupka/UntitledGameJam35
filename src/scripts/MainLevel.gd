extends Node2D

var arcade_control = preload("res://src/levels/ArcadeControl.tscn")
var can_interact = true

func _process(_delta):
	pass

func _on_DoorArea_body_entered(body):
	print("woop ", body)
	if body.is_in_group("MainPlayer"):
		GameController.enter_arcade()



