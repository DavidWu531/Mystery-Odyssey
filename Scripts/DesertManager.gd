extends Node2D

var boulder = preload("res://Scenes/boulder.tscn")

func _ready():
	SignalBus.checkpoint_iii_hit.connect(checkpoint_iii_hit)
	SignalBus.checkpoint_iv_hit.connect(checkpoint_iv_hit)


func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $PyramidAccess/Interactable.visible:
			for node in $PyramidAccess.get_overlapping_bodies():
				if "Player" in node.name:
					$AnimationPlayer.play("blackfadein")
					await get_tree().create_timer(1.05).timeout
					node.position = Vector2(96, 3744)
					break


func checkpoint_iii_hit():
	$Checkpoints/CheckpointIII.set_deferred("monitorable", false)
	$Checkpoints/CheckpointIII.set_deferred("monitoring", false)
	$Checkpoints/CheckpointIII/CollisionShape2D.set_deferred("disabled", true)


func checkpoint_iv_hit():
	$Checkpoints/CheckpointIV.set_deferred("monitorable", false)
	$Checkpoints/CheckpointIV.set_deferred("monitoring", false)
	$Checkpoints/CheckpointIV/CollisionShape2D.set_deferred("disabled", true)


func _on_quicksand_body_entered(body):
	if "Player" in body.name:
		body.velocity = Vector2(0,0)
		body.speed = 98.3
		body.gravity = 10.0
		body.jump_velocity = 210.0


func _on_quicksand_body_exited(body):
	if "Player" in body.name:
		body.speed = body.normal_speed
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


func _on_spikes_section_ii_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$FallingSpikesDetection/SpikesSectionII/AnimationPlayer.play("spikessection2")
