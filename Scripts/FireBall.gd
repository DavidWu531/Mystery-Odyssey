extends Area2D

var speed = 170

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	if position.x > 100000 or position.x < -100000 or position.y < -100000 or position.y > 100000:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.player_health -= 2.5
		await get_tree().create_timer(1.0).timeout
		queue_free()
