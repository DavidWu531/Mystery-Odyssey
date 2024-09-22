extends Node2D

var npci_dialogue_id = 0
var npcii_dialogue_id = 0
var npciv_dialogue_id = 0
var npcv_dialogue_id = 0
var npci_talked = false
var npcii_talked = false
var npciii_talked = false
var npciv_talked = false
var npcv_talked = false

func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)


func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $NPCs/NPCI/Interactable.visible:
			for node in $NPCs/NPCI.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
			$CanvasLayer/NPCI.show()
			if npci_dialogue_id == 0:
				$CanvasLayer/NPCI/Dialogue.text = "Greetings, traveller"
			elif npci_dialogue_id == 1:
				$CanvasLayer/NPCI/Dialogue.text = "I see you're wandering around this wild realm"
			elif npci_dialogue_id == 2:
				$CanvasLayer/NPCI/Dialogue.text = "See those spiky grass over there? Yeah, you don't want to touch them"
			else:
				$CanvasLayer/NPCI/Dialogue.text = ""
				$CanvasLayer/NPCI.hide()
				$NPCs/NPCI/Interactable.hide()
				for node in $NPCs/NPCI.get_overlapping_bodies():
					if "Player" in node.name:
						node.can_move = true
			npci_dialogue_id += 1
			if not npci_talked:
				npci_talked = true
				SignalBus.npc_talked_to.emit()
				Global.social_expert_progress += 1
		
		if $NPCs/NPCII/Interactable.visible:
			for node in $NPCs/NPCII.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
			$CanvasLayer/NPCII.show()
			if npcii_dialogue_id == 0:
				$CanvasLayer/NPCII/Dialogue.text = "You never know what might be lurking around..."
			elif npcii_dialogue_id == 1:
				$CanvasLayer/NPCII/Dialogue.text = "That's why you have a torch, radial or angular just press 1"
			elif npcii_dialogue_id == 2:
				$CanvasLayer/NPCII/Dialogue.text = "Or if you're confident, you can punch it with LMB"
			else:
				$CanvasLayer/NPCII/Dialogue.text = ""
				$NPCs/NPCII/Interactable.hide()
				for node in $NPCs/NPCII.get_overlapping_bodies():
					if "Player" in node.name:
						node.can_move = true
				$CanvasLayer/NPCII.hide()
			npcii_dialogue_id += 1
			if not npcii_talked:
				npcii_talked = true
				SignalBus.npc_talked_to.emit()
				Global.social_expert_progress += 1
	
		if $NPCs/NPCIV/Interactable.visible:
			for node in $NPCs/NPCIV.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
			$CanvasLayer/NPCIV.show()

			if npciv_dialogue_id == 0:
				$CanvasLayer/NPCIV/Dialogue.text = "You can't traverse like this"
			elif npciv_dialogue_id == 1:
				$CanvasLayer/NPCIV/Dialogue.text = "Even if you can jump, the gap is too large"
			elif npciv_dialogue_id == 2:
				$CanvasLayer/NPCIV/Dialogue.text = "Hey, what's over on the left?"
			else:
				$CanvasLayer/NPCIV/Dialogue.text = ""
				$NPCs/NPCIV/Interactable.hide()
				for node in $NPCs/NPCIV.get_overlapping_bodies():
					if "Player" in node.name:
						node.can_move = true
				$CanvasLayer/NPCIV.hide()
			npciv_dialogue_id += 1
			if not npciv_talked:
				npciv_talked = true
				SignalBus.npc_talked_to.emit()
				Global.social_expert_progress += 1
				
		if $NPCs/NPCV/Interactable.visible:
			for node in $NPCs/NPCV.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
			$CanvasLayer/NPCV.show()
				
			if npcv_dialogue_id == 0:
				$CanvasLayer/NPCV/Dialogue.text = "These pads look useful..."
			elif npcv_dialogue_id == 1:
				$CanvasLayer/NPCV/Dialogue.text = "Or not..."
			else:
				$CanvasLayer/NPCV/Dialogue.text = ""
				$NPCs/NPCV/Interactable.hide()
				for node in $NPCs/NPCV.get_overlapping_bodies():
					if "Player" in node.name:
						node.can_move = true
				$CanvasLayer/NPCV.hide()
			npcv_dialogue_id += 1
			if not npcv_talked:
				npcv_talked = true
				SignalBus.npc_talked_to.emit()
				Global.social_expert_progress += 1


func _physics_process(_delta: float) -> void:
	pass

func _on_npci_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCI/Interactable.show()
		
		
func _on_npci_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCI/Interactable.hide()
		npci_dialogue_id = 0
		$CanvasLayer/NPCI.hide()
		
		
func checkpoint_i_hit():
	$Platforms.set_cell(Vector2i(25,-23), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(Vector2i(25,-22), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(Vector2i(25,-21), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(Vector2i(25,-20), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(Vector2i(25,-19), 0, Vector2i(0,0), 6)
	$Platforms.set_cell(Vector2i(25,-18), 0, Vector2i(0,0), 6)
	
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
	$Platforms.set_cell(Vector2i(73,-13), -1, Vector2i(0,0), -1)
	$Platforms.set_cell(Vector2i(74,-13), -1, Vector2i(0,0), -1)
	SignalBus.maze_escaped.emit()
	

func checkpoint_ii_hit():
	$Platforms.set_cell(Vector2i(73,-13), 0, Vector2i(0,0), 0)
	$Platforms.set_cell(Vector2i(74,-13), 0, Vector2i(0,0), 0)
	
	$Checkpoints/CheckpointII.set_deferred("monitorable", false)
	$Checkpoints/CheckpointII.set_deferred("monitoring", false)
	$Checkpoints/CheckpointII/CollisionShape2D.set_deferred("disabled", true)

func _on_npcii_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCII/Interactable.show()


func _on_npcii_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCII/Interactable.hide()
		npcii_dialogue_id = 0
		$CanvasLayer/NPCII.hide()


func _on_npciii_body_entered(body):
	if "Player" in body.name:
		$CanvasLayer/NPCIII.show()
		if not npciii_talked:
			npciii_talked = true
			SignalBus.npc_talked_to.emit()
			Global.social_expert_progress += 1


func _on_npciii_body_exited(body):
	if "Player" in body.name:
		$CanvasLayer/NPCIII.hide()


func _on_npciv_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCIV/Interactable.show()


func _on_npciv_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCIV/Interactable.hide()
		npciv_dialogue_id = 0
		$CanvasLayer/NPCIV.hide()


func _on_door_body_entered(body):
	if "Player" in body.name:
		get_tree().change_scene_to_file("res://Scenes/won.tscn")


func _on_npcv_body_entered(body):
	if "Player" in body.name:
		$NPCs/NPCV/Interactable.show()


func _on_npcv_body_exited(body):
	if "Player" in body.name:
		$NPCs/NPCV/Interactable.hide()
		npcv_dialogue_id = 0
		$CanvasLayer/NPCV.hide()


func _on_block_i_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if $HelpfulBlocks/BlockI/Label.text == "HIT ME!!!":
			$HelpfulBlocks/BlockI/Label.text = "You can press Tab to show and scroll through tips"
			SignalBus.helpful_block_hit.emit()


func _on_block_ii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if $HelpfulBlocks/BlockII/Label.text == "HIT ME!!!":
			$HelpfulBlocks/BlockII/Label.text = "Watch out for patrolling enemies"
			SignalBus.helpful_block_hit.emit()


func _on_block_iii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if $HelpfulBlocks/BlockIII/Label.text == "HIT ME!!!":
			$HelpfulBlocks/BlockIII/Label.text = "Jump down the crater and press E. Hover your mouse over the top left"
			SignalBus.helpful_block_hit.emit()

func _on_block_iv_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if $HelpfulBlocks/BlockIV/Label.text == "HIT ME!!!":
			$HelpfulBlocks/BlockIV/Label.text = "Jump down and wait... unless you're not ready yet"
			SignalBus.helpful_block_hit.emit()


func _on_block_v_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if $HelpfulBlocks/BlockV/Label.text == "HIT ME!!!":
			$HelpfulBlocks/BlockV/Label.text = "Walk through the press and press E. Hover your mouse over the top left"
			SignalBus.helpful_block_hit.emit()
