extends Area2D

var touching_light = false
var attack_id = 1
var target = null
var timer_multiplier = 1.0

var speed = 50
var velocity = Vector2.ZERO
var is_on_floor = false
var enemy_count_scale = 1

var ice_shot = preload("res://Scenes/ice_shot.tscn")
var fire_ball = preload("res://Scenes/fire_ball.tscn")
var laser_poison = preload("res://Scenes/laser_poison.tscn")
var enemy = preload("res://Scenes/enemy.tscn")

func _ready() -> void:
	SignalBus.boss_spawned.connect(boss_spawned)


func _physics_process(delta: float) -> void:
	if not is_on_floor:
		velocity.y += gravity * delta
	
	is_on_floor = $RayCast2D.is_colliding()
	
	if target:
		var direction = (target.position - position).normalized()
		velocity.x = direction.x * speed
		$Marker2D.look_at(target.position)
	
	if is_on_floor:
		velocity.y = 0
	
	position += velocity * delta


func _process(_delta: float) -> void:
	if touching_light:
		Global.boss_health -= 0.1
	if Global.boss_health <= 0:
		SignalBus.boss_defeated.emit()
		queue_free()
	
	if Global.boss_health <= 200:
		timer_multiplier = 0.2
		$AnimatedSprite2D.speed_scale = 1.0 / timer_multiplier
		enemy_count_scale = 5
	elif Global.boss_health <= 400:
		timer_multiplier = 0.4
		$AnimatedSprite2D.speed_scale = 1.0 / timer_multiplier
		enemy_count_scale = 4
	elif Global.boss_health <= 600:
		timer_multiplier = 0.6
		$AnimatedSprite2D.speed_scale = 1.0 / timer_multiplier
		enemy_count_scale = 3
	elif Global.boss_health <= 800:
		timer_multiplier = 0.8
		$AnimatedSprite2D.speed_scale = 1.0 / timer_multiplier
		enemy_count_scale = 2
	else:
		timer_multiplier = 1.0
		$AnimatedSprite2D.speed_scale = 1.0 / timer_multiplier
		enemy_count_scale = 1


func _on_attack_timer_timeout() -> void:
	$AnimatedSprite2D.stop()
	attack_id += 1
	$AnimatedSprite2D.play("attacking")
	await get_tree().create_timer(1.25 * timer_multiplier).timeout
	$AnimatedSprite2D.pause()
	if attack_id % 8 == 0:
		$AttackTimer.start(4.5 * timer_multiplier)
		var new_laserpoison = laser_poison.instantiate()
		new_laserpoison.global_position = $Marker2D.global_position
		new_laserpoison.global_rotation = $Marker2D.global_rotation
		get_tree().root.add_child(new_laserpoison)
	elif attack_id % 5 == 0:
		$AttackTimer.start(2.25 * timer_multiplier)
		for i in range(3 * enemy_count_scale):
			var new_enemy = enemy.instantiate()
			new_enemy.position = position + Vector2(randi_range(-100, 100), randi_range(-100, 100))
			get_tree().root.add_child(new_enemy)
	elif attack_id % 3 == 0:
		$AttackTimer.start(2.25 * timer_multiplier)
		var new_fireball = fire_ball.instantiate()
		new_fireball.global_position = $Marker2D.global_position
		new_fireball.global_rotation = $Marker2D.global_rotation
		get_tree().root.add_child(new_fireball)
	else:
		$AttackTimer.start(2.25 * timer_multiplier)
		var new_iceshot = ice_shot.instantiate()
		new_iceshot.global_position = $Marker2D.global_position
		new_iceshot.global_rotation = $Marker2D.global_rotation
		get_tree().root.add_child(new_iceshot)
	if attack_id % 8 == 0:
		await get_tree().create_timer(4.5 * timer_multiplier + 0.1).timeout
	await get_tree().create_timer(0.25).timeout
	$AnimatedSprite2D.stop()
	

func _on_player_detection_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		target = body


func boss_spawned():
	$AttackTimer.start(2.25)


func _on_player_detection_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		target = null
