extends Node3D

var NoA
var UI
var playerInArea = false
var difficulty = 50.0
# Called when the node enters the scene tree for the first time.
func _ready():
	NoA = get_tree().root.get_node("World").numberOfAltars
	UI = get_tree().root.get_node("World/UI")
	var output = []
	OS.execute("C:/Users/mlabedzk/AppData/Local/Microsoft/WindowsApps/python3.10.exe",["d:/_KrakJam2024/Make a Face/MakeAFace/CameraProcessing/camera.py"],output)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_enterd_area(body):
	if body.is_in_group("player"):
		playerInArea = true
		if get_tree().root.get_node("World").numberOfAltars >= 3:
			UI.get_child(0).get_child(1).get_child(0).hide()
			#play sound "if you are able to scare me you'll be free, 3, 2, 1, make a face
			pass
		else:
			#enable UI to lose (make scream laugh)
			pass
		var o = []
		OS.execute("C:/Users/mlabedzk/AppData/Local/Microsoft/WindowsApps/python3.10.exe",["d:/_KrakJam2024/Make a Face/MakeAFace/CameraProcessing/captureAndCount.py"],o)
		var error = float(o[0])
		print(error)
		
		if error < difficulty:
			print("you died")
		else:
			print("spared")
		difficulty += 10

func _on_body_exited_area(body):
	if body.is_in_group("player"):
		playerInArea = false
		print("aaaaa")
