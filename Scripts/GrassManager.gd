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
