extends Node2D

var boss_dialogue_id = 0
var boss_talked = true
var boss_mode = false
var boss = preload("res://Scenes/boss.tscn")

var npcix_dialogue_id = 0
var npcx_dialogue_id = 0
var npcix_talked = false
var npcx_talked = false

func _ready() -> void:
	SignalBus.checkpoint_vi_hit.connect(checkpoint_vi_hit)
	SignalBus.checkpoint_vii_hit.connect(checkpoint_vii_hit)
	SignalBus.boss_spawned.connect(boss_spawned)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if $ExitCave/Interactable.visible:
			for node in $ExitCave.get_overlapping_bodies():
				if "Player" in node.name:
					node.position = Vector2(2368, -10224)
					Global.escape_cave_progress = 1
		
		if $BossAltar/Interactable.visible:
			for node in $BossAltar/PlayerDetection.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
			$CanvasLayer/BossAltar.show()
			if boss_dialogue_id == 0:
				$CanvasLayer/BossAltar/Dialogue.text = "Who dares to disturb my slumber?"
			elif boss_dialogue_id == 1:
				$CanvasLayer/BossAltar/Dialogue.text = "You dare challenge me, mortal?"
			elif boss_dialogue_id == 2:
				$CanvasLayer/BossAltar/Dialogue.text = "There's no going back for you..."
			elif boss_dialogue_id == 3:
				$CanvasLayer/BossAltar/Dialogue.text = "Prepare to suffer!"
			else:
				$CanvasLayer/BossAltar/Dialogue.text = ""
				for node in $BossAltar/PlayerDetection.get_overlapping_bodies():
					if "Player" in node.name:
						node.can_move = true
				$CanvasLayer/BossAltar.hide()
				var tween = get_tree().create_tween()
				tween.tween_property($BossAltar, "position", Vector2(15072, -8984), 0.5)
				await get_tree().create_timer(1.0).timeout
				
			boss_dialogue_id += 1
			if not boss_talked:
				boss_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1
		
		if $NPCs/NPCIX/Interactable.visible:
			for node in $NPCs/NPCIX.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
			$CanvasLayer/NPCIX.show()
			if npcix_dialogue_id == 0:
				$CanvasLayer/NPCIX/Dialogue.text = "Geez, it's cold here"
			if npcix_dialogue_id == 1:
				$CanvasLayer/NPCIX/Dialogue.text = "You must have came a long way"
			if npcix_dialogue_id == 2:
				$CanvasLayer/NPCIX/Dialogue.text = "And of course, more challenges await"
			if npcix_dialogue_id == 3:
				$CanvasLayer/NPCIX/Dialogue.text = "Icicles, ice, harmful water..."
			if npcix_dialogue_id == 4:
				$CanvasLayer/NPCIX/Dialogue.text = "You get the idea, every hazard is cold-related"
			if npcix_dialogue_id == 5:
				$CanvasLayer/NPCIX/Dialogue.text = "You're nearly there!"
			else:
				$CanvasLayer/NPCIX/Dialogue.text = ""
				$NPCs/NPCIX/Interactable.hide()
				for node in $NPCs/NPCIX.get_overlapping_bodies():
					if "Player" in node.name:
						node.can_move = true
				$CanvasLayer/NPCIX.hide()
			npcix_dialogue_id += 1
			if not npcix_talked:
				npcix_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1
		
		if $NPCs/NPCX/Interactable.visible:
			for node in $NPCs/NPCX.get_overlapping_bodies():
				if "Player" in node.name:
					node.can_move = false
			$CanvasLayer/NPCX.show()
			if npcx_dialogue_id == 0:
				$CanvasLayer/NPCX/Dialogue.text = "One of us told you about Andona, didn't they?"
			if npcx_dialogue_id == 1:
				$CanvasLayer/NPCX/Dialogue.text = "You were sent here to kill it, I presume?"
			if npcx_dialogue_id == 2:
				$CanvasLayer/NPCX/Dialogue.text = "Good... that creature wanted to destroy this realm"
			if npcx_dialogue_id == 3:
				$CanvasLayer/NPCX/Dialogue.text = "So glad someone is brave enough to fight it"
			if npcx_dialogue_id == 4:
				$CanvasLayer/NPCX/Dialogue.text = "However, it's not easy... he's ruthless"
			if npcx_dialogue_id == 5:
				$CanvasLayer/NPCX/Dialogue.text = "Good Luck, Player! Everyone on this world salutes you!"
			else:
				$CanvasLayer/NPCX/Dialogue.text = ""
				$NPCs/NPCX/Interactable.hide()
				for node in $NPCs/NPCX.get_overlapping_bodies():
					if "Player" in node.name:
						node.can_move = true
				$CanvasLayer/NPCX.hide()
			npcx_dialogue_id += 1
			if not npcx_talked:
				npcx_talked = true
				SignalBus.npc_talked.emit()
				Global.social_expert_progress += 1
		
	if $BossAltar.position == Vector2(15072,-8984) and not boss_mode:
		boss_mode = true
		SignalBus.boss_spawned.emit()


func _on_exit_cave_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$ExitCave/Interactable.show()


func _on_exit_cave_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$ExitCave/Interactable.hide()
		
		
func checkpoint_vi_hit():
	$Checkpoints/CheckpointVI.set_deferred("monitorable", false)
	$Checkpoints/CheckpointVI.set_deferred("monitoring", false)
	$Checkpoints/CheckpointVI/CollisionShape2D.set_deferred("disabled", true)


func checkpoint_vii_hit():
	$Checkpoints/CheckpointVII.set_deferred("monitorable", false)
	$Checkpoints/CheckpointVII.set_deferred("monitoring", false)
	$Checkpoints/CheckpointVII/CollisionShape2D.set_deferred("disabled", true)


func boss_spawned():
	var newboss = boss.instantiate()
	newboss.position = Vector2(15784, -13904)
	get_tree().root.add_child(newboss)
	
	for y in range(-210,-241,-1):
		$Platforms.set_cell(Vector2i(218, y), 22, Vector2i(0,0), 3)
	for x in range(218,272):
		$Platforms.set_cell(Vector2i(x, -240), 22, Vector2i(0,0), 1)
	for y in range(-210,-241,-1):
		$Platforms.set_cell(Vector2i(271, y), 22, Vector2i(0,0), 2)


func _on_player_detection_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$BossAltar/Interactable.show()


func _on_player_detection_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$BossAltar/Interactable.hide()
		boss_dialogue_id = 0
		$CanvasLayer/BossAltar/Dialogue.text = ""


func _on_npcix_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCIX/Interactable.show()


func _on_npcix_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCIX/Interactable.hide()
		npcix_dialogue_id = 0
		$CanvasLayer/NPCIX/Dialogue.text = ""


func _on_npcx_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCX/Interactable.show()


func _on_npcx_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$NPCs/NPCX/Interactable.hide()
		npcx_dialogue_id = 0
		$CanvasLayer/NPCX/Dialogue.text = ""
