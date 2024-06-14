extends Node2D

var npci_dialogue = 0

func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $NPCs/NPCI/Interactable.visible:
			if npci_dialogue == 0:
				$NPCs/NPCI/Dialogue.text = "Hello, traveller"
			elif npci_dialogue == 1:
				$NPCs/NPCI/Dialogue.text = "Wait, where have I seen you before?"
			elif npci_dialogue == 2:
				$NPCs/NPCI/Dialogue.text = "Anyway, whatever you're doing, watch out for obstacles"
			else:
				$NPCs/NPCI/Dialogue.text = ""
				$NPCs/NPCI/Interactable.hide()
			npci_dialogue += 1

func _on_npci_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCI/Interactable.show()
		
func _on_npci_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCI/Interactable.hide()
		npci_dialogue = 0
		$NPCs/NPCI/Dialogue.text = ""


func _on_change_zone_body_entered(body):
	if "Player" in body.name:
		var animationsprite = body.get_node("Sprite2D")
		animationsprite.play("Temp2")

func _on_gate_shut_body_entered(body):
	if "Player" in body.name:
		var animationsprite = body.get_node("Sprite2D")
		animationsprite.play("Temp1")
		
		$Obstacles.set_cell(0, Vector2i(164, -104), -1, Vector2i(0,0), -1)
		$Platforms.set_cell(0, Vector2i(164, -104), 0, Vector2i(0,0), 6)
		$Platforms.set_cell(0, Vector2i(164, -100), 0, Vector2i(0,0), 6)
		$Platforms.set_cell(0, Vector2i(164, -96), 0, Vector2i(0,0), 6)
		$Platforms.set_cell(0, Vector2i(164, -92), 0, Vector2i(0,0), 6)
		$Platforms.set_cell(0, Vector2i(164, -88), 0, Vector2i(0,0), 6)
		$Platforms.set_cell(0, Vector2i(164, -84), 0, Vector2i(0,0), 6)
		$Platforms.set_cell(0, Vector2i(164, -80), 0, Vector2i(0,0), 6)
		$Platforms.set_cell(0, Vector2i(164, -76), 3, Vector2i(0,0), 0)


func _on_hatch_open_body_entered(body):
	if "Player" in body.name:
		body.position = $Jumpscaro/Revert.position
		body.gravity = 980.0
		
		$Platforms.set_cell(0, Vector2i(188, -76), -1, Vector2i(0,0), -1)
		$Platforms.set_cell(0, Vector2i(192, -76), -1, Vector2i(0,0), -1)
		$Platforms.set_cell(0, Vector2i(196, -76), -1, Vector2i(0,0), -1)
		$Platforms.set_cell(0, Vector2i(200, -76), -1, Vector2i(0,0), -1)
		$Platforms.set_cell(0, Vector2i(204, -76), -1, Vector2i(0,0), -1)
		$Platforms.set_cell(0, Vector2i(208, -76), -1, Vector2i(0,0), -1)
		
		$Obstacles.set_cell(0, Vector2i(188, -80), -1, Vector2i(0,0), -1)
		$Obstacles.set_cell(0, Vector2i(192, -80), -1, Vector2i(0,0), -1)
		$Obstacles.set_cell(0, Vector2i(196, -80), -1, Vector2i(0,0), -1)
		$Obstacles.set_cell(0, Vector2i(200, -80), -1, Vector2i(0,0), -1)
		$Obstacles.set_cell(0, Vector2i(204, -80), -1, Vector2i(0,0), -1)
		$Obstacles.set_cell(0, Vector2i(208, -80), -1, Vector2i(0,0), -1)

func _on_revert_body_entered(body):
	if "Player" in body.name:
		var animationsprite = body.get_node("Sprite2D")
		animationsprite.play("Temp1")
