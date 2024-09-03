extends Node2D

var boulder = preload("res://Scenes/boulder.tscn")
var n = 126
var breakable_health = 3

var npcvi_dialogue_id = 0
var npcviii_dialogue_id = 0

var npcvi_talked = false
var npcvii_talked = false
var npcviii_talked = false

func _ready():
	SignalBus.checkpoint_iii_hit.connect(checkpoint_iii_hit)
	SignalBus.checkpoint_iv_hit.connect(checkpoint_iv_hit)
	SignalBus.checkpoint_v_hit.connect(checkpoint_v_hit)
	SignalBus.doomed.connect(doomed)
	
	for node in $Other/Hidden.get_children():
		node.text = str(randi_range(0,9))


func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $PyramidAccess/Interactable.visible:
			for node in $PyramidAccess.get_overlapping_bodies():
				if "Player" in node.name:
					$AnimationPlayer.play("blackfadein")
					await get_tree().create_timer(1.05).timeout
					node.position = Vector2(88, 6256)
					if not Global.i_c_u:
						Global.i_c_u_progress = 1
					break
		
		if $Other/Door/Interactable.visible:
			$Other/Door/Keypad.show()
			for node in $Other/Door.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
					node.z_index = -1
		
		if $NPCs/NPCVI/Interactable.visible:
			if npcvi_dialogue_id == 0:
				$NPCs/NPCVI/Dialogue.text = "Watch out for quicksand. You'll sink in them..."
			elif npcvi_dialogue_id == 1:
				$NPCs/NPCVI/Dialogue.text = "And rolling boulders too"
			elif npcvi_dialogue_id == 2:
				$NPCs/NPCVI/Dialogue.text = "Jeez... this place is hazardous..."
			else:
				$NPCs/NPCVI/Dialogue.text = ""
				$NPCs/NPCVI/Interactable.hide()
			npcvi_dialogue_id += 1
			if not npcvi_talked:
				npcvi_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1
		
		if $NPCs/NPCVIII/Interactable.visible:
			if npcviii_dialogue_id == 0:
				$NPCs/NPCVIII/Dialogue.text = "Getting hot in here..."
			elif npcviii_dialogue_id == 1:
				$NPCs/NPCVIII/Dialogue.text = "Well, you can't go back so..."
			elif npcviii_dialogue_id == 2:
				$NPCs/NPCVIII/Dialogue.text = "Find a way to escape..."
			elif npcviii_dialogue_id == 3:
				$NPCs/NPCVIII/Dialogue.text = "And don't touch the tungsten cube!!"
			else:
				$NPCs/NPCVIII/Dialogue.text = ""
				$NPCs/NPCVIII/Interactable.hide()
			npcviii_dialogue_id += 1
			if not npcviii_talked:
				npcvi_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1
	
	if breakable_health <= 0:
		$Platforms.set_cell(Vector2i(178,75), -1, Vector2i(-1,-1), -1)
		$Platforms.set_cell(Vector2i(178,76), -1, Vector2i(-1,-1), -1)
		$Platforms.set_cell(Vector2i(178,77), -1, Vector2i(-1,-1), -1)


func checkpoint_iii_hit():
	$Checkpoints/CheckpointIII.set_deferred("monitorable", false)
	$Checkpoints/CheckpointIII.set_deferred("monitoring", false)
	$Checkpoints/CheckpointIII/CollisionShape2D.set_deferred("disabled", true)


func checkpoint_iv_hit():
	$Checkpoints/CheckpointIV.set_deferred("monitorable", false)
	$Checkpoints/CheckpointIV.set_deferred("monitoring", false)
	$Checkpoints/CheckpointIV/CollisionShape2D.set_deferred("disabled", true)


func checkpoint_v_hit():
	$Checkpoints/CheckpointV.set_deferred("monitorable", false)
	$Checkpoints/CheckpointV.set_deferred("monitoring", false)
	$Checkpoints/CheckpointV/CollisionShape2D.set_deferred("disabled", true)
	
	Global.enter_cave_progress = 1


func _on_quicksand_body_entered(body):
	if "Player" in body.name:
		body.on_quicksand = true
		body.velocity = Vector2(0,0)
		Global.player_speed = 98.3
		body.gravity = 10.0
		body.jump_velocity = 210.0


func _on_quicksand_body_exited(body):
	if "Player" in body.name:
		body.on_quicksand = false
		Global.player_speed = body.NORMAL_SPEED
		body.gravity = 980.0 * 1.75
		body.jump_velocity = 625.0 * 1.4


func _on_boulder_timer_timeout():
	var new_boulder = boulder.instantiate()
	new_boulder.position = Vector2(14368, -1968)
	add_child(new_boulder)


func _on_hidden_key_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$Other/HiddenKey.hide()
		$Other/HiddenKey.set_deferred("monitorable", false)
		$Other/HiddenKey.set_deferred("monitoring", false)
		$Other/HiddenKey/CollisionShape2D.set_deferred("disabled", true)
		Global.score += 1


func _on_pyramid_access_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if not $Other/HiddenKey.visible:
			$PyramidAccess/Interactable.show()
		else:
			$PyramidAccess/Error.show()


func _on_pyramid_access_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$PyramidAccess/Interactable.hide()
		$PyramidAccess/Error.hide()


func _on_boulder_wreck_body_entered(body: Node2D) -> void:
	if "Boulder" in body.name:
		await get_tree().create_timer(0.5).timeout
		body.queue_free()


func _on_spiky_ball_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.player_health -= 2
		body.death_engine()


func _on_dripstone_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.player_health -= 3
		body.death_engine()


func _on_spikes_section_i_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$FallingSpikesDetection/SpikesSectionI/AnimationPlayer.play("spikessection1")
		$FallingSpikesDetection/SpikesSectionI.set_deferred("monitoring", false)
		$FallingSpikesDetection/SpikesSectionI.set_deferred("monitorable", false)
		$FallingSpikesDetection/SpikesSectionI/CollisionShape2D.set_deferred("disabled", true)


func _on_spikes_section_ii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$FallingSpikesDetection/SpikesSectionII/AnimationPlayer.play("spikessection2")
		$FallingSpikesDetection/SpikesSectionII.set_deferred("monitoring", false)
		$FallingSpikesDetection/SpikesSectionII.set_deferred("monitorable", false)
		$FallingSpikesDetection/SpikesSectionII/CollisionShape2D.set_deferred("disabled", true)


func _on_door_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$Other/Door/Interactable.show()
		body.z_index = 1


func _on_door_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$Other/Door/Interactable.hide()
		body.z_index = 1
		

func doomed():
	for tile in range(43,127):
		$Platforms.set_cell(Vector2i(104, tile), 35, Vector2i(0,0), 0)
	for tile in range(106,178):
		$Platforms.set_cell(Vector2i(tile, 99), -1, Vector2i(-1,-1), -1)
	$DoomedLavaRise.start(2.142857143)
	$Other/Hidden/PinI.position = Vector2(11264, 3264)
	$Other/Hidden/PinII.position = Vector2(11264, 3968)
	$Other/Hidden/PinIII.position = Vector2(11264, 5632)
	$Other/Hidden/PinIV.position = Vector2(11264, 6464)
	pass  # Fool! You have doomed us all!


func _on_doomed_lava_rise_timeout() -> void:
	for x in range(105,178):
		$Obstacles.set_cell(Vector2(x, n), 5, Vector2i(0,0), 0)
	if n > 43:
		n -= 1
	else:
		$DoomedLavaRise.stop()


func _on_doomed_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.player_health -= 1.5


func _on_npcvi_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCVI/Interactable.show()


func _on_npcvi_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCVI/Interactable.hide()
		npcvi_dialogue_id = 0
		$NPCs/NPCVIII/Dialogue.text = ""


func _on_npcvii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCVII/Dialogue.show()
		if not npcvii_talked:
			npcvii_talked = true
			SignalBus.npc_talked.emit()
			Global.social_expert_progress += 1


func _on_npcvii_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCVII/Dialogue.hide()


func _on_npcviii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCVIII/Interactable.show()


func _on_npcviii_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCVIII/Interactable.hide()
		npcviii_dialogue_id = 0
		$NPCs/NPCVIII/Dialogue.text = ""


func _on_block_vi_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$HelpfulBlocks/BlockVI/Label.text = "Press R to respawn if you ever get softlocked"


func _on_block_vii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$HelpfulBlocks/BlockVII/Label.text = "Lava will instantly damage you, or bounce you up in no-respawn mode"


func _on_block_viii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$HelpfulBlocks/BlockVIII/Label.text = "Push the tungsten cube into lava, you're not progressing until then"


func _on_gravity_flip_instant_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		body.current_mode = body.player_modes[2]
