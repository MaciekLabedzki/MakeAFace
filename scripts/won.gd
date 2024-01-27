extends Node3D
# Called when the node enters the scene tree for the first time.
func _input(event):
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
