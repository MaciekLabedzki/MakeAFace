extends Area3D

var isPlayerNear = false
var NoA
var UI

func _ready():
	NoA = get_tree().root.get_node("World").numberOfAltars
	UI = get_tree().root.get_node("World/UI")

func _input(event):
	if Input.is_action_just_pressed("interact") and isPlayerNear:
		$altarLight.show()
		$altarParticles.show()
		NoA += 1
		#get_tree().root.get_node("World").numberOfAltars +=1
		if NoA == 1:
			UI.get_child(0).get_child(0).get_child(0).hide()
			UI.get_child(0).get_child(0).get_child(1).show()
			# play sound
		elif NoA == 2:
			UI.get_child(0).get_child(0).get_child(1).hide()
			UI.get_child(0).get_child(0).get_child(2).show()
			# play sound
		elif NoA == 3:
			UI.get_child(0).get_child(0).get_child(2).hide()
			UI.get_child(0).get_child(0).get_child(3).show()
			# play sound

func _on_body_enterd_area(body):
	if body.is_in_group("player") and not $altarLight.is_visible():
		UI.get_child(0).get_child(0).get_child(4).show()
		isPlayerNear = true
			
func _on_body_left_area(body):
	if body.is_in_group("player"):
		UI.get_child(0).get_child(0).get_child(4).hide()
		isPlayerNear = false
