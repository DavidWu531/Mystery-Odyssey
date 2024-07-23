extends Area2D

func _on_body_entered(body):
	if "Player" in body.name:
		body.pad_launch()


func _on_body_exited(body):
	if "Player" in body.name:
		body.pad_delaunch()
