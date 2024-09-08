extends Area2D

func _ready() -> void:
	$DespawnTimer.start(4.6)


func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		body.touching_laser = true
		

func _on_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		body.touching_laser = false


func _on_despawn_timer_timeout() -> void:
	queue_free()
