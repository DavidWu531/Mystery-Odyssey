extends Area2D

func _ready():
	pass

func _process(_delta):
	pass

func _on_body_entered(body):
	if "Player" in body.name:
		$AnimatedSprite2D.play("Hit")
		body.respawn_pos = position
