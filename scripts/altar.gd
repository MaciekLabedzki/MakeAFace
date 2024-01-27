extends Area3D

var isPlayerNear = false
var UI

func _ready():
	UI = get_tree().root.get_node("World/UI")

func _input(event):
	if Input.is_action_just_pressed("interact") and isPlayerNear and not is_in_group("active"):
		add_to_group("active")
		$altarLight.show()
		$altarParticles.show()
		get_tree().root.get_node("World").numberOfAltars += 1

		if get_tree().root.get_node("World").numberOfAltars == 1:
			UI.get_child(0).get_child(0).get_child(0).hide()
			UI.get_child(0).get_child(0).get_child(1).show()
			# play sound
		elif get_tree().root.get_node("World").numberOfAltars == 2:
			UI.get_child(0).get_child(0).get_child(1).hide()
			UI.get_child(0).get_child(0).get_child(2).show()
			# play sound
		elif get_tree().root.get_node("World").numberOfAltars == 3:
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
