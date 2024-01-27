extends Button

func _pressed():
	print("start")
	get_tree().change_scene_to_file("res://scenes/World.tscn")
