extends CharacterBody2D

var speed = 0
var jump_velocity = 625.0 * 1.4

var respawn_pos = Vector2(0,0)
var take_damage_respos = Vector2(0,0)
var respawn_gravity = 980.0 * 1.75
var old_position = position

const half_speed = 383.1
const normal_speed = 475.0
const double_speed = 590.7
const triple_speed = 713.9
const quadruple_speed = 878.2
const PUSH_FORCE = 100
const MAX_VELOCITY = 150

var gravity = 980.0 * 1.75
var jump_count = 1
var can_move = true
var linear_moving = false
var on_ice = false
var on_pad = false
var direction_normalised
var direction_x
var tile_vector : Vector2i

var current_mode = "Default"
var player_modes = ["Default", "DoubleJump", "GravityFlip", "LinearMotion"]

func _ready():
	speed = normal_speed
	respawn_pos = position
	take_damage_respos = position
	
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)


func _physics_process(delta):
	if not linear_moving:
		velocity.y += gravity * delta
		$LinearDirection.look_at(get_global_mouse_position())
	
	$AngularLight.look_at(get_global_mouse_position())

	if Input.is_anything_pressed():
		if not Global.grassland_explored and Global.grassland_explored_progress == 0:
			Global.grassland_explored_progress += 1
	
	
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
		if current_mode == player_modes[0]:
			current_mode = player_modes[1]
		elif current_mode == player_modes[1]:
			current_mode = player_modes[2]
		elif current_mode == player_modes[2]:
			current_mode = player_modes[3]
		elif current_mode == player_modes[3]:
			current_mode = player_modes[0]
	
	if Input.is_action_just_pressed("Jump"):
		if can_move:
			respawn_gravity = gravity
			if current_mode == "DoubleJump":
				if jump_count > 0:
					if is_on_floor() or is_on_ceiling():
						take_damage_respos = position
					if gravity > 0.0:
						velocity.y = -jump_velocity
					elif gravity < 0.0:
						velocity.y = jump_velocity
					jump_count -= 1
			elif current_mode == "Default":
				if is_on_floor() or is_on_ceiling():
					take_damage_respos = position
					if gravity > 0.0:
						velocity.y = -jump_velocity
					elif gravity < 0.0:
						velocity.y = jump_velocity
			elif current_mode == "GravityFlip":
				if is_on_floor() or is_on_ceiling():
					take_damage_respos = position
					if gravity > 0.0:
						velocity.y = -1000.0
					elif gravity < 0.0:
						velocity.y = 1000.0
					gravity = -gravity


		if gravity > 0.0:
			$Sprite2D.flip_v = false
		elif gravity < 0.0:
			$Sprite2D.flip_v = true
		
	if Input.is_action_pressed("Jump"):
		if can_move:
			if current_mode == "LinearMotion":
				linear_moving = true
				velocity = Vector2(cos($LinearDirection.rotation) * speed, sin($LinearDirection.rotation) * speed)
	
	if Input.is_action_just_released("Jump"):
		if current_mode == "LinearMotion":
			linear_moving = false
			velocity = Vector2(0,0)
		
	if Input.is_action_just_pressed("FastDrop"):
		if can_move:
			if gravity > 0.0:
				velocity.y = jump_velocity * 5
			elif gravity < 0.0:
				velocity.y = -jump_velocity * 5
	
	direction_x = Input.get_axis("Left", "Right")
	if can_move:
		if current_mode != "LinearMotion":
			if direction_x:
				velocity.x = direction_x * speed
				$Sprite2D.play("walking")
				if direction_x == 1:
					$Sprite2D.offset.x = 160
					$Sprite2D.flip_h = false
				elif direction_x == -1:
					$Sprite2D.offset.x = -160
					$Sprite2D.flip_h = true
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
				$Sprite2D.play("static")
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
	
	if on_pad:
		velocity.y = -jump_velocity * 1.5
	
	if velocity == Vector2(0, gravity * delta):
		$KeysHold.start(10.0)
	
	direction_normalised = velocity.normalized()

	move_and_slide()

func _process(_delta):
	if direction_normalised.x > 0.0:
		tile_vector.x = 1
		tile_vector.y = 0
	elif direction_normalised.x < 0.0:
		tile_vector.x = -1
		tile_vector.y = 0
	elif direction_normalised.y > 0.0:
		tile_vector.y = 1
		tile_vector.x = 0
	elif direction_normalised.y < 0.0:
		tile_vector.y = -1
		tile_vector.x = 0
	#print(direction_normalised, tile_vector)

	if position.y > 10000 or position.y < -10000:
		Global.player_health -= 1
		death_engine()
		
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if "Obstacles" in collision.get_collider().name:
			var tile = collision.get_collider().local_to_map(position) + tile_vector
			"""- (Vector2(52,87) / 2) + (Vector2(64,64) / 2)"""
			print(tile)
			if collision.get_collider().get_cell_source_id(0, tile) == 2:
				Global.player_health -= 1
			elif collision.get_collider().get_cell_source_id(0, tile) == 3 \
			or (collision.get_collider().get_cell_source_id(0, tile) == 4 \
			or collision.get_collider().get_cell_source_id(0, tile) == 5):
				Global.player_health -= 3
				break
			gravity = respawn_gravity
			velocity = Vector2(0,0)
			can_move = false
			$SpawnImmunity.start(2.0)
			$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.0)
			Global.no_stopping_now_progress += 1
			if Global.player_health <= 0:
				position = respawn_pos
				take_damage_respos = respawn_pos
				Global.player_health = Global.player_maxhealth
				gravity = respawn_gravity
				SignalBus.player_died.emit()
			elif Global.player_health >= 1:
				position = take_damage_respos
			break
		
		elif "Platforms" in collision.get_collider().name:
			if collision.get_collider().get_cell_source_id(0, collision.get_collider().local_to_map(position) + Vector2i(0,1)) == 4:
				if not Global.desert_explored and Global.desert_explored_progress == 0:
					Global.desert_explored_progress += 1
			if collision.get_collider().get_cell_source_id(0, collision.get_collider().local_to_map(position) + Vector2i(0,1)) == 5:
				if not Global.frostland_explored and Global.frostland_explored_progress == 0:
					Global.frostland_explored_progress += 1
			break
		
		elif "MovableBlock" in collision.get_collider().name:
			if abs(collision.get_collider().get_linear_velocity().x) < MAX_VELOCITY:
				collision.get_collider().apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
				
	
	if Input.is_action_just_pressed("TorchToggle"):
		if $AngularLight.enabled:
			$AngularLight.enabled = false
			$RadialLight.enabled = true
		elif $RadialLight.enabled:
			$AngularLight.enabled = false
			$RadialLight.enabled = false
		else:
			$AngularLight.enabled = true
			$RadialLight.enabled = false
	
	if $AngularLight.enabled or $RadialLight.enabled:
		Global.player_energy -= 0.0001
		if Global.player_energy <= 0.0:
			$AngularLight.enabled = false
			$RadialLight.enabled = false
	elif not $AngularLight.enabled and not $RadialLight.enabled:
		if Global.player_energy < 50.0:
			Global.player_energy += 0.075

	$AngularLight.offset = Vector2(45.5 * (5 * Global.torch_level) - 32, 0)
	$AngularLight.texture_scale = 5 * Global.torch_level
	
	$RadialLight.texture_scale = 2.5 * Global.torch_level


func death_engine():
	gravity = respawn_gravity
	velocity = Vector2(0,0)
	can_move = false
	$SpawnImmunity.start(2.0)
	$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.no_stopping_now_progress += 1
	if Global.player_health <= 0:
		position = respawn_pos
		take_damage_respos = respawn_pos
		Global.player_health = Global.player_maxhealth
		gravity = respawn_gravity
		SignalBus.player_died.emit()
	elif Global.player_health >= 1:
		position = take_damage_respos

func _on_res_pos_timer_timeout():
	if (is_on_floor() and gravity > 0.0) or (is_on_ceiling() and gravity < 0.0):
		take_damage_respos = position


func checkpoint_ii_hit():
	$Camera2D.enabled = true
	current_mode = player_modes[0]


func pad_launch():
	on_pad = true


func pad_delaunch():
	on_pad = false


func _on_keys_hold_timeout():
	Global.cant_let_go_progress = 1


func _on_spawn_immunity_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	await get_tree().create_timer(1.0).timeout
	can_move = true
