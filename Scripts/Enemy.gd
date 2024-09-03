extends CharacterBody2D

var health = 10
var n = 0
var target = null

var gravity = 980.0
var speed = 200.0
var jump_velocity = 625.0
var value = randi_range(-1, 1)
var movable = true
var knocked_back = false
var direction = Vector2(value, value).normalized()

var touching_light = false

func _ready():
	n += 1
	$Healthbar.max_value = health

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	name = "Enemy" + str(n)
	if health <= 0:
		Global.killing_machine_progress += 1
		queue_free()
	
	if target:
		velocity = (target.position - position).normalized() * speed
		velocity.y += gravity * delta
	elif target == null:
		if movable:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
	
	if is_on_wall():
		velocity.y = -jump_velocity
	
	if direction.x < 0 and direction.x > -1:
		$Sprite2D.scale.x = -0.1
	elif direction.x > 0 and direction.x < 1:
		$Sprite2D.scale.x = 0.1
	
	move_and_slide()


func _process(_delta: float) -> void:
	if touching_light:
		health -= 0.05
	
	$Healthbar.value = health


func _on_range_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		target = body


func _on_range_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		target = null
	

func _on_moving_timer_timeout() -> void:
	movable = false


func _on_direction_timer_timeout() -> void:
	value = randi_range(-1, 1)
	velocity = Vector2.ZERO
	direction = Vector2(value, 0).normalized()
	movable = true
	$MovingTimer.start()
