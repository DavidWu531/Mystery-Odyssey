extends Area2D

func _ready() -> void:
	if Global.boss_health <= 200:
		$AnimationPlayer.play("rotate_fast+")
	elif Global.boss_health <= 400:
		$AnimationPlayer.play("rotate_fast")
	elif Global.boss_health <= 600:
		$AnimationPlayer.play("rotate_med")
	elif Global.boss_health <= 800:
		$AnimationPlayer.play("rotate_slow")
	else:
		$AnimationPlayer.play("rotate_slow+")
	
	$DespawnTimer.start($AnimationPlayer.current_animation_length + 0.1)


func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		body.touching_laser = true
		

func _on_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		body.touching_laser = false


func _on_despawn_timer_timeout() -> void:
	queue_free()
