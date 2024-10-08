extends CharacterBody2D

var health = 10 * Settings.difficulty_amplifier
var n = 0
var target = null

var gravity = 980.0
var speed = 200.0
var jump_velocity = 625.0
var value = randi_range(-1, 1)
var movable = true
var stunned = false
var direction = Vector2(value, value).normalized()

var touching_light = false

func _ready():
	n += 1
	$Healthbar.max_value = health


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	name = "Enemy" + str(n)
	if health <= 0:
		Global.killing_machine_progress += 1
		SignalBus.enemy_slayed.emit()
		queue_free()
	
	if not stunned:
		if target:
			velocity.x = (target.position - position).normalized().x * speed
		elif target == null:
			if movable:
				velocity.x = direction.x * speed
			else:
				velocity = Vector2.ZERO
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
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
	direction = Vector2(value, direction.y).normalized()
	movable = true
	$MovingTimer.start()


func _on_stun_timer_timeout() -> void:
	stunned = false


func temp_stunned():
	stunned = true
	$StunTimer.start(1.75)
