extends CharacterBody2D

var speed = 0
const JUMP_VELOCITY = 625.0

var respawn_pos = Vector2(0,0)
var take_damage_respos = Vector2(0,0)

const half_speed = 383.1
const normal_speed = 475.0
const double_speed = 590.7
const triple_speed = 713.9
const quadruple_speed = 878.2

var gravity = 980.0

var time_elapsed = 0.00

var object_mode = "Default"

func _ready():
	speed = normal_speed
	respawn_pos = position
	take_damage_respos = position
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
		if $Sprite2D.animation == "Temp1":
			$Sprite2D.play("Temp2")
		elif $Sprite2D.animation == "Temp2":
			$Sprite2D.play("Temp1")
	
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() or is_on_ceiling():
			take_damage_respos = position
			if $Sprite2D.animation == "Temp1":
				if gravity > 0.0:
					velocity.y = -JUMP_VELOCITY
				elif gravity < 0.0:
					velocity.y = JUMP_VELOCITY
			elif $Sprite2D.animation == "Temp2":
				if gravity > 0.0:
					velocity.y = -1000.0
				elif gravity < 0.0:
					velocity.y = 1000.0
				gravity = -gravity
		
	if Input.is_action_just_pressed("FastDrop"):
		if gravity > 0.0:
			velocity.y = JUMP_VELOCITY * 5
		elif gravity < 0.0:
			velocity.y = -JUMP_VELOCITY * 5

	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
func _process(_delta):
	if position.y > 10000 or position.y < -10000:
		Global.player_health -= 1
		gravity = 980.0
		velocity = Vector2(0,0)
		if Global.player_health <= 0:
			position = respawn_pos
			Global.player_health = 3
			SignalBus.player_died.emit()
		elif Global.player_health >= 1:
			position = take_damage_respos
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if "Obstacles" in collision.get_collider().name:
			Global.player_health -= 1
			gravity = 980.0
			velocity = Vector2(0,0)
			if Global.player_health <= 0:
				position = respawn_pos
				take_damage_respos = respawn_pos
				Global.player_health = 3
				SignalBus.player_died.emit()
			elif Global.player_health >= 1:
				position = take_damage_respos
			break

func checkpoint_i_hit():
	pass
