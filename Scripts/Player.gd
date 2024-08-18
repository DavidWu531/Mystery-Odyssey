extends CharacterBody2D

var speed = 0
var jump_velocity = 625.0 * 1.4

var respawn_pos = Vector2(0,0)
var take_damage_respos = Vector2(0,0)
var respawn_gravity = 980.0 * 1.75
var old_position = position
var heart_lost = false

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
var tile = null
var min_distance = INF
var platform_tile_vector : Vector2i
var grass_plat_tiles = [0, 3, 6, 7, 8, 11, 12, 13, 14]
var desert_plat_tiles = [4, 9, 15, 16, 17, 18, 20]
var frost_plat_tiles = [5, 10, 19]
var grass_obst_tiles = [2]
var desert_obst_tiles = [3, 4]
var frost_obst_tiles = []


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
			platform_tile_vector = Vector2i(0,1)
		elif gravity < 0.0:
			$Sprite2D.flip_v = true
			platform_tile_vector = Vector2i(0,-1)
		
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
				if on_ice:
					if direction_x != 0:
						velocity.x += direction_x * delta * speed
					else:
						velocity.x *= 0.95
				else:
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

func _process(delta):
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if "Obstacles" in collision.get_collider().name:
			min_distance = INF
			tile = null
			var tile_damage_taken = false
			var map_pos = collision.get_collider().local_to_map(position)
			for y in range(-50, 50):
				for x in range(-50, 50):
					var cell_id = collision.get_collider().get_cell_source_id(\
					map_pos + Vector2i(x, y))
					if cell_id != -1:
						var temp_local_coord = collision.get_collider().map_to_local(map_pos + Vector2i(x, y))
						var distance = position.distance_to(temp_local_coord)
						
						if distance < min_distance:
							min_distance = distance
							tile = map_pos + Vector2i(x, y)
						$Label.text = str(tile)
			
			if tile and not tile_damage_taken:
				if collision.get_collider().get_cell_source_id(tile) in grass_obst_tiles:
					Global.player_health -= 1
					tile_damage_taken = true
				elif collision.get_collider().get_cell_source_id(tile) in desert_obst_tiles:
					Global.player_health -= 3
					tile_damage_taken = true
				
				if tile_damage_taken:
					death_engine()
					break
		
		elif "Platforms" in collision.get_collider().name:
			if collision.get_collider().get_cell_source_id(collision.get_collider().local_to_map(position) + platform_tile_vector) in grass_plat_tiles:
				if not Global.grassland_explored:
					if velocity != Vector2(0, 0):
						Global.grassland_explored_progress += 1
			if collision.get_collider().get_cell_source_id(collision.get_collider().local_to_map(position) + platform_tile_vector) in desert_plat_tiles:
				if not Global.desert_explored:
					if velocity != Vector2(0, 0):
						Global.desert_explored_progress += 1
			if collision.get_collider().get_cell_source_id(collision.get_collider().local_to_map(position) + platform_tile_vector) in frost_plat_tiles:
				if not Global.frostland_explored:
					if velocity != Vector2(0, 0):
						Global.frostland_explored_progress += 1
			
			if collision.get_collider().get_cell_source_id(collision.get_collider().local_to_map(position) + Vector2i(0,1)) == 19:
				on_ice = true
			else:
				on_ice = false
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
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.no_stopping_now_progress += 1
	heart_lost = true
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
	$CollisionShape2D.set_deferred("disabled", false)
	can_move = true
