extends Area2D


func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $Interactable.visible:
			for node in get_overlapping_bodies():
				if "Player" in node.name:
					if not $AnimatedSprite2D.is_playing():
						var animation_tween = get_tree().create_tween()
						animation_tween.tween_property(node, "position", position + Vector2(0, 50), 1.5).set_trans(Tween.TRANS_BOUNCE)
						$AnimatedSprite2D.play("default")
						node.can_move = false
						await $AnimatedSprite2D.animation_finished
						SignalBus.double_jump_silhouette.emit()
						node.current_mode = node.player_modes[1]
						node.can_move = true
						$Interactable.hide()
						break


func _on_body_entered(body):
	if "Player" in body.name:
		$Interactable.show()


func _on_body_exited(body):
	if "Player" in body.name:
		$Interactable.hide()
