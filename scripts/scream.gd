extends Node3D

var UI
var playerInArea = false
var difficulty = 50.0
var player
var timer
var timerWasTimedOut = true
# Called when the node enters the scene tree for the first time.
func _ready():
	UI = get_tree().root.get_node("World/UI")
	player = get_tree().root.get_node("World/GridMap/player")
	#play intro sound
	UI.get_child(0).get_child(1).get_child(10).show()
	await get_tree().create_timer(1.0).timeout
	UI.get_child(0).get_child(1).get_child(10).hide()
	var output = []
	OS.execute("C:/Users/mlabedzk/AppData/Local/Microsoft/WindowsApps/python3.10.exe",["d:/_KrakJam2024/Make a Face/MakeAFace/CameraProcessing/camera.py"],output)

func _input(_event):
	if Input.is_action_just_pressed("exit") and not playerInArea:
		UI.get_child(0).get_child(1).get_child(8).show()
		timer = get_tree().create_timer(1.0)
		timerWasTimedOut = false
		print("exit")
	
		
func _process(_delta):
	if timer:
		if timer.time_left <= 0 and not timerWasTimedOut:
			timerWasTimedOut = true
			UI.get_child(0).get_child(1).get_child(8).hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_enterd_area(body):
	if body.is_in_group("player") and not playerInArea:
		playerInArea = true
		var X = Vector2(player.position.x,player.position.z)
		var Y = -X.direction_to(Vector2(position.x,position.z))
		player.rotate_y(deg_to_rad(Y.dot(X)))
		if get_tree().root.get_node("World").numberOfAltars >= 3:
			#scare me
			
			UI.get_child(0).get_child(1).get_child(5).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(5).hide()
			#play sound "if you are able to scare me you'll be free
			
		else:
			#laugh me
			UI.get_child(0).get_child(1).get_child(4).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(4).hide()
		
		#play sound 3, 2, 1, make a face
		
		#3
		UI.get_child(0).get_child(1).get_child(0).show()
		await get_tree().create_timer(1.0).timeout
		UI.get_child(0).get_child(1).get_child(0).hide()
		#2
		UI.get_child(0).get_child(1).get_child(1).show()
		await get_tree().create_timer(1.0).timeout
		UI.get_child(0).get_child(1).get_child(1).hide()
		#1
		UI.get_child(0).get_child(1).get_child(2).show()
		await get_tree().create_timer(1.0).timeout
		UI.get_child(0).get_child(1).get_child(2).hide()
		#make a face
		UI.get_child(0).get_child(1).get_child(3).show()
		await get_tree().create_timer(0.5).timeout
		
		var o = []
		OS.execute("C:/Users/mlabedzk/AppData/Local/Microsoft/WindowsApps/python3.10.exe",["d:/_KrakJam2024/Make a Face/MakeAFace/CameraProcessing/captureAndCount.py"],o)
		await get_tree().create_timer(0.5).timeout
		UI.get_child(0).get_child(1).get_child(3).hide()
		var error = float(o[0])
		
		if error < difficulty:
			print("you died")
			#u died
			#play death sound
			UI.get_child(0).get_child(1).get_child(7).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(7).hide()
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
		elif get_tree().root.get_node("World").numberOfAltars >= 3:
			print("won")
			get_tree().change_scene_to_file("res://scenes/won.tscn")
		else:
			#spared
			#play laugh sound
			UI.get_child(0).get_child(1).get_child(6).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(6).hide()
			print("spared")
		difficulty += 10
		playerInArea = false

func _on_body_exited_area(body):
	if body.is_in_group("player"):
		playerInArea = false
