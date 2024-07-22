extends Node2D

var npci_dialogue_id = 0
var npcii_dialogue_id = 0
var npciv_dialogue_id = 0
var npci_talked = false
var npcii_talked = false
var npciii_talked = false
var npciv_talked = false

func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)


func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $NPCs/NPCI/Interactable.visible:
			if npci_dialogue_id == 0:
				$NPCs/NPCI/Dialogue.text = "Greetings, traveller"
			elif npci_dialogue_id == 1:
				$NPCs/NPCI/Dialogue.text = "I see you're wandering around this wild realm"
			elif npci_dialogue_id == 2:
				$NPCs/NPCI/Dialogue.text = "See those spiky grass over there? Yeah, you don't want to touch them"
			else:
				$NPCs/NPCI/Dialogue.text = ""
				$NPCs/NPCI/Interactable.hide()
			npci_dialogue_id += 1
			if not npci_talked:
				npci_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1
		
		if $NPCs/NPCII/Interactable.visible:
			if npcii_dialogue_id == 0:
				$NPCs/NPCII/Dialogue.text = "I wonder how you get up there"
			elif npcii_dialogue_id == 1:
				$NPCs/NPCII/Dialogue.text = "Maybe there's something in that crater?"
			elif npcii_dialogue_id == 2:
				$NPCs/NPCII/Dialogue.text = "You never know what might be lurking around..."
			else:
				$NPCs/NPCII/Dialogue.text = ""
				$NPCs/NPCII/Interactable.hide()
			npcii_dialogue_id += 1
			if not npcii_talked:
				npcii_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1
	
		if $NPCs/NPCIV/Interactable.visible:
			if npciv_dialogue_id == 0:
				$NPCs/NPCIV/Dialogue.text = "You can't traverse like this"
			elif npciv_dialogue_id == 1:
				$NPCs/NPCIV/Dialogue.text = "Even if you can jump, the gap is too large"
			elif npciv_dialogue_id == 2:
				$NPCs/NPCIV/Dialogue.text = "Hey, what's over on the left?"
			else:
				$NPCs/NPCIV/Dialogue.text = ""
				$NPCs/NPCIV/Interactable.hide()
			npciv_dialogue_id += 1
			if not npciv_talked:
				npciv_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1

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
		$DoubleJumpTip/Instruction.show()


func _on_double_jump_tip_body_exited(body):
	if "Player" in body.name:
		$DoubleJumpTip/Instruction.hide()


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
	$Platforms.set_cell(0, Vector2i(294,-52), -1, Vector2i(0,0), -1)
	$Platforms.set_cell(0, Vector2i(298,-52), -1, Vector2i(0,0), -1)


func checkpoint_ii_hit():
	$Platforms.set_cell(0, Vector2i(294,-52), 0, Vector2i(0,0), 0)
	$Platforms.set_cell(0, Vector2i(298,-52), 0, Vector2i(0,0), 0)


func _on_npcii_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCII/Interactable.show()


func _on_npcii_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCII/Interactable.hide()
		npcii_dialogue_id = 0
		$NPCs/NPCII/Dialogue.text = ""


func _on_npciii_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCIII/Dialogue.show()
		if not npciii_talked:
			npciii_talked = true
			SignalBus.npc_talked.emit()
			Global.social_expert_progress += 1


func _on_npciii_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCIII/Dialogue.hide()


func _on_npciv_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCIV/Interactable.show()


func _on_npciv_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCIV/Interactable.hide()
		npciv_dialogue_id = 0
		$NPCs/NPCII/Dialogue.text = ""


func _on_door_body_entered(body):
	if "Player" in body.name:
		get_tree().change_scene_to_file("res://Scenes/won.tscn")
