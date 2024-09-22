extends Area2D

var speed = 400

func _ready() -> void:
	if randf() >= 0.5:
		big()
	else:
		small()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	if position.x > 100000 or position.x < -100000 or position.y < -100000 or position.y > 100000:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if not body.damage_immune:
			Global.player_health -= 0.75 * Settings.difficulty_amplifier
			body.death_engine()
			queue_free()
			

func small():
	speed = 800
	scale = Vector2(2,2)
	
	
func big():
	speed = 400
	scale = Vector2(4,4)
