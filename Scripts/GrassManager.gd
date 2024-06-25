extends Node2D

var npci_dialogue = 0

func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)


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
		
		
func checkpoint_i_hit():
	$Platforms.set_cell(0, Vector2i(102,-92), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-88), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-84), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-80), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-76), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-72), 0, Vector2i(0,0), 6)


func _on_sign_movement_body_entered(body):
	if "Player" in body.name:
		$SignMovement/Control.show()


func _on_sign_movement_body_exited(body):
	if "Player" in body.name:
		$SignMovement/Control.hide()


func _on_lily_vanish_body_entered(body):
	if "Player" in body.name:
		$LilyVanish/LilyTimer.start(2.5)


func _on_lily_vanish_body_exited(body):
	if "Player" in body.name:
		$LilyVanish/LilyTimer.stop()


func _on_lily_timer_timeout():
	$Platforms.set_cell(0, Vector2i(206,-68), -1, Vector2i(0,0), -1)
	$Platforms.set_cell(0, Vector2i(210,-68), -1, Vector2i(0,0), -1)
	await get_tree().create_timer(2.5).timeout
	$Platforms.set_cell(0, Vector2i(206,-68), 0, Vector2i(0,0), 0)
	$Platforms.set_cell(0, Vector2i(210,-68), 0, Vector2i(0,0), 0)
	
