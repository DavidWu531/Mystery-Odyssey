extends CharacterBody2D

var health = 10
var n = 0
var target = null
var counter = 1

var gravity = 980
var speed = 200
var value = randf_range(-1, 1)
var movable = true
var direction = Vector2(value, value).normalized()

func _ready():
	n += 1

func _process(delta):
	velocity.y += gravity * delta
	
	name = "Enemy" + str(n)
	if health <= 0:
		queue_free()
	
	if target:
		velocity = (target.position - position).normalized() * speed
	else:
		if movable:
			velocity = direction * speed
			
	move_and_slide()
	

func _on_range_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		target = body


func _on_range_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		target = null


func _on_moving_timer_timeout() -> void:
	movable = false


func _on_direction_timer_timeout() -> void:
	value = randf_range(-1, 1)
	direction = Vector2(value, value).normalized()
	movable = true
