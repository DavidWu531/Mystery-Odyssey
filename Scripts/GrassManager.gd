extends Node2D

var npci_dialogue_id = 0
var npci_talked = false

func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)


func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $NPCs/NPCI/Interactable.visible:
			if npci_dialogue_id == 0:
				$NPCs/NPCI/Dialogue.text = "Hello, traveller"
			elif npci_dialogue_id == 1:
				$NPCs/NPCI/Dialogue.text = "Wait, where have I seen you before?"
			elif npci_dialogue_id == 2:
				$NPCs/NPCI/Dialogue.text = "Anyway, whatever you're doing, watch out for obstacles"
			else:
				$NPCs/NPCI/Dialogue.text = ""
				$NPCs/NPCI/Interactable.hide()
			npci_dialogue_id += 1
			if not npci_talked:
				npci_talked = true
				SignalBus.npc_talked.emit()
	

func _on_npci_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCI/Interactable.show()
		
		
func _on_npci_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCI/Interactable.hide()
		npci_dialogue_id = 0
		$NPCs/NPCI/Dialogue.text = ""
		
		
func checkpoint_i_hit():
	$Platforms.set_cell(0, Vector2i(102,-92), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-88), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-84), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-80), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-76), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(0, Vector2i(102,-72), 0, Vector2i(0,0), 6)
	
	$Checkpoints/CheckpointI.set_deferred("monitorable", false)
	$Checkpoints/CheckpointI.set_deferred("monitoring", false)
	$Checkpoints/CheckpointI/CollisionShape2D.set_deferred("disabled", true)


func _on_gravity_flip_tip_body_entered(body):
	if "Player" in body.name:
		$GravityFlipTip/Instruction.show()


func _on_gravity_flip_tip_body_exited(body):
	if "Player" in body.name:
		$GravityFlipTip/Instruction.hide()


func _on_double_jump_tip_body_entered(body):
	if "Player" in body.name:
		pass


func _on_double_jump_tip_body_exited(body):
	if "Player" in body.name:
		pass


func _on_linear_motion_tip_body_entered(body):
	if "Player" in body.name:
		pass


func _on_linear_motion_tip_body_exited(body):
	if "Player" in body.name:
		pass

func _on_lily_vanish_body_entered(body):
	if "Player" in body.name:
		$LilyVanish/LilyTimer.start(2.5)


func _on_lily_vanish_body_exited(body):
	if "Player" in body.name:
		$LilyVanish/LilyTimer.stop()


func _on_lily_timer_timeout():
	$Platforms.set_cell(0, Vector2i(206,-68), -1, Vector2i(0,0), -1)
	$Platforms.set_cell(0, Vector2i(210,-68), -1, Vector2i(0,0), -1)


func checkpoint_ii_hit():
	$Platforms.set_cell(0, Vector2i(206,-68), 0, Vector2i(0,0), 0)
	$Platforms.set_cell(0, Vector2i(210,-68), 0, Vector2i(0,0), 0)
	
