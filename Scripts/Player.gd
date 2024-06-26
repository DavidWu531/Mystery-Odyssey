extends CharacterBody2D

var speed = 0
const JUMP_VELOCITY = 625.0

var respawn_pos = Vector2(0,0)
var take_damage_respos = Vector2(0,0)
var respawn_gravity = 980.0

const half_speed = 383.1
const normal_speed = 475.0
const double_speed = 590.7
const triple_speed = 713.9
const quadruple_speed = 878.2

var gravity = 980.0
var jump_count = 1
var can_move = true

var current_mode = "Default"
var player_modes = ["Default", "DoubleJump", "GravityFlip"]

func _ready():
	speed = normal_speed
	respawn_pos = position
	take_damage_respos = position

func _physics_process(delta):
	velocity.y += gravity * delta
	
	$PointLight2D.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
		if current_mode == player_modes[0]:
			current_mode = player_modes[1]
		elif current_mode == player_modes[1]:
			current_mode = player_modes[2]
		elif current_mode == player_modes[2]:
			current_mode = player_modes[0]
	
	if Input.is_action_just_pressed("Jump"):
		if can_move:
			respawn_gravity = gravity
			if current_mode == "DoubleJump":
				if jump_count > 0:
					take_damage_respos = position
					if gravity > 0.0:
						velocity.y = -JUMP_VELOCITY
					elif gravity < 0.0:
						velocity.y = JUMP_VELOCITY
					jump_count -= 1
			elif current_mode == "Default":
				if is_on_floor() or is_on_ceiling():
					take_damage_respos = position
					if gravity > 0.0:
						velocity.y = -JUMP_VELOCITY
					elif gravity < 0.0:
						velocity.y = JUMP_VELOCITY
			elif current_mode == "GravityFlip":
				if is_on_floor() or is_on_ceiling():
					take_damage_respos = position
					if gravity > 0.0:
						velocity.y = -1000.0
					elif gravity < 0.0:
						velocity.y = 1000.0
					gravity = -gravity
		else:
			velocity = Vector2(0,0)

		
	if Input.is_action_just_pressed("FastDrop"):
		if can_move:
			if gravity > 0.0:
				velocity.y = JUMP_VELOCITY * 5
			elif gravity < 0.0:
				velocity.y = -JUMP_VELOCITY * 5
		else:
			velocity = Vector2(0,0)

	var direction = Input.get_axis("Left", "Right")
	if can_move:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
		velocity = Vector2(0,0)
	
	if gravity > 0.0:
		if is_on_floor():
			if current_mode == "DoubleJump":
				jump_count = 1
	elif gravity < 0.0:
		if is_on_ceiling():
			if current_mode == "DoubleJump":
				jump_count = 1
	
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
			gravity = respawn_gravity
			velocity = Vector2(0,0)
			if Global.player_health <= 0:
				position = respawn_pos
				take_damage_respos = respawn_pos
				Global.player_health = 3
				gravity = 980
				SignalBus.player_died.emit()
			elif Global.player_health >= 1:
				position = take_damage_respos
			break

func _on_res_pos_timer_timeout():
	if (is_on_floor() and gravity > 0.0) or (is_on_ceiling() and gravity < 0.0):
		take_damage_respos = position
