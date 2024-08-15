extends Area2D

func _ready():
	pass


func _process(_delta):
	pass


func _on_body_entered(body):
	if "Player" in body.name:
		$AnimatedSprite2D.play("Hit")
		body.respawn_pos = body.position
		body.take_damage_respos = body.position
		
		if not SignalBus.checkpoint_i_emitted and SignalBus.checkpoint_i_available:
			SignalBus.checkpoint_i_hit.emit()
			SignalBus.checkpoint_i_emitted = true
			SignalBus.checkpoint_ii_available = true
		elif not SignalBus.checkpoint_ii_emitted and SignalBus.checkpoint_ii_available:
			SignalBus.checkpoint_ii_hit.emit()
			SignalBus.checkpoint_ii_emitted = true
			SignalBus.checkpoint_iii_available = true
		elif not SignalBus.checkpoint_iii_emitted and SignalBus.checkpoint_iii_available:
			SignalBus.checkpoint_iii_hit.emit()
			SignalBus.checkpoint_iii_emitted = true
		
		if not Global.ultra_insticto and Global.ultra_insticto_progress == 0:
			if not body.heart_lost:
				Global.ultra_insticto_progress += 1
			else:
				body.heart_lost = false
		
