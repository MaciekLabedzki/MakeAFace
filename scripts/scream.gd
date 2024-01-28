extends Node3D

var UI
var playerInArea = false
var difficulty = 50.0
var player
var timer
var timerWasTimedOut = true
var SPEED = 5.0
var navAgent
var target: Node3D = null
var setTarget: bool = false
var velocity
var listOfPoints
var rng
var timerDeactivate
var timerDeWasTimedOut = true
var p
var soundTimer
var soundTimer2

# Called when the node enters the scene tree for the first time.
func _ready():
	navAgent = $NavigationAgent3D
	listOfPoints = gatherNavPoints()
	p = get_tree().root.get_node("World/NavigationRegion3D/GridMap/player/p")
	rng = RandomNumberGenerator.new()
	UI = get_tree().root.get_node("World/UI")
	player = get_tree().root.get_node("World/NavigationRegion3D/GridMap/player")
	#play intro sound
	UI.get_child(0).get_child(1).get_child(10).show()
	await get_tree().create_timer(1.0).timeout
	UI.get_child(0).get_child(1).get_child(10).hide()
	var output = []
	OS.execute("C:/Users/mlabedzk/AppData/Local/Microsoft/WindowsApps/python3.10.exe",["d:/_KrakJam2024/Make a Face/MakeAFace/CameraProcessing/camera.py"],output)
	
func gatherNavPoints():
	var list = []
	var childrensOfGrid = get_tree().root.get_node("World/NavigationRegion3D/GridMap").get_children()
	for child in childrensOfGrid:
		if child is Marker3D:
			list.append(child)
	return list

func pickRandomNavPoint(listPoints):
	return listPoints[rng.randi_range(0,len(listPoints)-1)]

func huntPlayer():
	target = get_tree().root.get_node("World/NavigationRegion3D/GridMap/player/p")
	navAgent.target_position = target.global_position
	SPEED = 16.0

func _input(_event):
	if Input.is_action_just_pressed("exit") and not playerInArea:
		UI.get_child(0).get_child(1).get_child(8).show()
		timer = get_tree().create_timer(1.0)
		timerWasTimedOut = false

func _process(_delta):
	if timer:
		if timer.time_left <= 0 and not timerWasTimedOut:
			timerWasTimedOut = true
			UI.get_child(0).get_child(1).get_child(8).hide()
	if timerDeactivate:
		if timerDeactivate.time_left <= 0 and not timerDeWasTimedOut:
			timerDeWasTimedOut = true
			SPEED = 5.0
			target = null
			get_node("CollisionShape3D/CollisionShape3D").disabled = false
	look_at(navAgent.get_next_path_position())
	
	#sound
	if soundTimer:
		if soundTimer.time_left <= 0:
			get_node("1").pitch_scale = randf_range(0.8,1.2)
			get_node("1").play()
			soundTimer = get_tree().create_timer(2)
		if soundTimer.time_left <= 1 and soundTimer.time_left >0:
			get_node("2").pitch_scale = randf_range(0.8,1.2)
			get_node("2").play()
		if soundTimer.time_left <= 1.5 and soundTimer.time_left >0.5:
			get_node("3").pitch_scale = randf_range(0.8,1.2)
			get_node("3").play()
	else:
		soundTimer = get_tree().create_timer(2)

func _physics_process(delta):
	if not target:
		var point
		while(not point or point.global_position.distance_to(global_position)<1.1):
			point = pickRandomNavPoint(listOfPoints)
		target = point
		navAgent.target_position = target.global_position
	else:
		velocity = global_position.direction_to(navAgent.get_next_path_position()) * SPEED
		global_position += velocity * delta
		if target.global_position.distance_to(global_position) <= 1:
			target = null
		if target == p:
			navAgent.target_position = target.global_position

func _on_body_enterd_area(body):
	if body.is_in_group("player") and not playerInArea:
		get_node("CollisionShape3D/CollisionShape3D").disabled = true
		playerInArea = true
		SPEED = 0.0
		player.look_at(position)
		if get_tree().root.get_node("World").numberOfAltars >= 3:
			#scare me
			playerInArea = true
			UI.get_child(0).get_child(1).get_child(5).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(5).hide()
			#play sound "if you are able to scare me you'll be free
			
		else:
			#laugh me
			playerInArea = true
			UI.get_child(0).get_child(1).get_child(4).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(4).hide()
		
		#play sound 3, 2, 1, make a face
		
		#3
		playerInArea = true
		UI.get_child(0).get_child(1).get_child(0).show()
		await get_tree().create_timer(1.0).timeout
		UI.get_child(0).get_child(1).get_child(0).hide()
		#2
		playerInArea = true
		UI.get_child(0).get_child(1).get_child(1).show()
		await get_tree().create_timer(1.0).timeout
		UI.get_child(0).get_child(1).get_child(1).hide()
		#1
		playerInArea = true
		UI.get_child(0).get_child(1).get_child(2).show()
		await get_tree().create_timer(1.0).timeout
		UI.get_child(0).get_child(1).get_child(2).hide()
		#make a face
		playerInArea = true
		UI.get_child(0).get_child(1).get_child(3).show()
		await get_tree().create_timer(0.5).timeout
		
		var o = []
		OS.execute("C:/Users/mlabedzk/AppData/Local/Microsoft/WindowsApps/python3.10.exe",["d:/_KrakJam2024/Make a Face/MakeAFace/CameraProcessing/captureAndCount.py"],o)
		playerInArea = true
		await get_tree().create_timer(0.5).timeout
		UI.get_child(0).get_child(1).get_child(3).hide()
		var error = float(o[0])
		timerDeactivate = get_tree().create_timer(5.0)
		timerDeWasTimedOut = false
		target = null
		playerInArea = true
		if error < difficulty:
			#u died
			#play death sound
			UI.get_child(0).get_child(1).get_child(7).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(7).hide()
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
		elif get_tree().root.get_node("World").numberOfAltars >= 3:
			get_tree().change_scene_to_file("res://scenes/won.tscn")
		else:
			#spared
			#play laugh sound
			UI.get_child(0).get_child(1).get_child(6).show()
			await get_tree().create_timer(1.0).timeout
			UI.get_child(0).get_child(1).get_child(6).hide()
		difficulty += 10
		playerInArea = false
		

func _on_body_exited_area(body):
	if body.is_in_group("player"):
		playerInArea = false
