extends CharacterBody2D

var jump_velocity = 625.0 * 1.4

var respawn_pos = Vector2(0,0)
var take_damage_respos = Vector2(0,0)
var respawn_gravity = 980.0 * 1.75
var old_position = position
var old_health
var original_polygon : PackedVector2Array
var attack_speed = 1 / 1.5
var coyote_time_left = 0.0
var laser_time_left = 0.0

const COYOTE_TIME = 0.2
const LASER_TIME = 2.75
const HALF_SPEED = 383.1
const NORMAL_SPEED = 475.0
const DOUBLE_SPEED = 590.7
const TRIPLE_SPEED = 713.9
const QUADRUPLE_SPEED = 878.2
const PUSH_FORCE = 100
const MAX_VELOCITY = 150

var gravity = 980.0 * 1.75
var jump_count = 1
var can_move = true
var can_attack = true
var heart_lost = false
var is_attacking = false
var linear_moving = false
var on_ice = false
var on_pad = false
var on_quicksand = false
var direction_x
var hardcore = false
var quick_retry = false
var touching_laser = false
var boss_mode = false
var damage_immune = false

var tile_vector : Vector2i
var tile = null
var min_distance = INF
var platform_tile_vector : Vector2i
var grass_plat_tiles = [0, 3, 6, 7, 8, 11, 12, 13, 14]
var desert_plat_tiles = [4, 9, 15, 16, 17, 18, 20]
var frost_plat_tiles = [5, 10, 19, 23, 30, 31, 37]
var ice_tiles = [19, 37]
var grass_obst_tiles = [2]
var desert_obst_tiles = [3, 4]
var frost_obst_tiles = [7]

var current_mode = "Default"
var player_modes = ["Default", "DoubleJump", "GravityFlip", "LinearMotion"]

func _ready():
	Global.player_speed = NORMAL_SPEED
	respawn_pos = position
	take_damage_respos = position
	
	original_polygon = $LightAttackAngular/AngularCollisionPolygon2D.polygon
	
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)
	SignalBus.checkpoint_iv_hit.connect(checkpoint_iv_hit)
	SignalBus.checkpoint_v_hit.connect(checkpoint_v_hit)
	SignalBus.checkpoint_vi_hit.connect(checkpoint_vi_hit)
	
	SignalBus.doomed.connect(doomed)
	SignalBus.undoomed.connect(undoomed)
	SignalBus.boss_spawned.connect(boss_spawned)
	SignalBus.boss_defeated.connect(boss_defeated)
	
	$LightAttackAngular/AngularLight.offset = Vector2(45.5 * (5 * Global.torch_level) - 32, 0)
	$LightAttackAngular/AngularLight.texture_scale = 5 * Global.torch_level
	var new_polygon = PackedVector2Array()
	for point in $LightAttackAngular/AngularCollisionPolygon2D.polygon.duplicate():
		point = Vector2(point.x / 10 * (5 * Global.torch_level), point.y / 10 * (5 * Global.torch_level))
		new_polygon.append(point)
	$LightAttackAngular/AngularCollisionPolygon2D.polygon = new_polygon
	$LightAttackAngular/AngularCollisionPolygon2D.position = $LightAttackAngular/AngularLight.offset
	
	$LightAttackRadial/RadialLight.texture_scale = 2.5 * Global.torch_level
	$LightAttackRadial/RadialCollisionShape2D.shape.radius = (91 * $LightAttackRadial/RadialLight.texture_scale)/2


func _physics_process(delta):
	if not linear_moving and not Global.spectator:
		velocity.y += gravity * delta
		$LinearDirection.look_at(get_global_mouse_position())
	
	$LightAttackAngular.look_at(get_global_mouse_position())
	
	if is_on_floor():
		coyote_time_left = COYOTE_TIME
	else:
		coyote_time_left -= delta
	
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
		if not Global.spectator:
			if can_move:
				if not is_attacking:
					respawn_gravity = gravity
					if current_mode == "DoubleJump":
						if jump_count > 0:
							if is_on_floor() or is_on_ceiling() or coyote_time_left > 0:
								take_damage_respos = position
							if gravity > 0.0:
								velocity.y = -jump_velocity
							elif gravity < 0.0:
								velocity.y = jump_velocity
							jump_count -= 1
							$JumpSFX.play()
					elif current_mode == "Default":
						if is_on_floor() or is_on_ceiling() or coyote_time_left > 0:
							take_damage_respos = position
							if gravity > 0.0:
								velocity.y = -jump_velocity
							elif gravity < 0.0:
								velocity.y = jump_velocity
							$JumpSFX.play()
					elif current_mode == "GravityFlip":
						if is_on_floor() or is_on_ceiling() or coyote_time_left > 0:
							take_damage_respos = position
							if gravity > 0.0:
								velocity.y = -1000.0
							elif gravity < 0.0:
								velocity.y = 1000.0
							gravity = -gravity
							$JumpSFX.play()

		if gravity > 0.0:
			$Sprite2D.flip_v = false
			platform_tile_vector = Vector2i(0,1)
		elif gravity < 0.0:
			$Sprite2D.flip_v = true
			platform_tile_vector = Vector2i(0,-1)
		
	if Input.is_action_pressed("Jump"):
		if not Global.spectator:
			if can_move:
				if current_mode == "LinearMotion":
					linear_moving = true
					velocity = Vector2(cos($LinearDirection.rotation) * Global.player_speed, sin($LinearDirection.rotation) * Global.player_speed)
		else:
			position.y -= Global.player_speed * delta
	
	if Input.is_action_just_released("Jump"):
		if current_mode == "LinearMotion":
			linear_moving = false
			velocity = Vector2(0,0)
		
	if Input.is_action_just_pressed("FastDrop"):
		if not Global.spectator:
			if can_move:
				if gravity > 0.0:
					velocity.y = jump_velocity * 5
				elif gravity < 0.0:
					velocity.y = -jump_velocity * 5
	
	if Input.is_action_pressed("FastDrop"):
		if Global.spectator:
			position.y += Global.player_speed * delta
	
	direction_x = Input.get_axis("Left", "Right")
	if Global.spectator:
		position.x += direction_x * 10
	else:
		if current_mode != "LinearMotion":
			if can_move:
				if not is_attacking:
					if direction_x:
						if on_ice:
							velocity.x += direction_x * delta * Global.player_speed
						else:
							velocity.x = direction_x * Global.player_speed
						$Sprite2D.play("walking")
						if Global.player_speed > NORMAL_SPEED:
							Global.player_energy -= (Global.player_speed / NORMAL_SPEED) / 60.0
							$EnergyRegeneration.stop()
					else:
						if on_ice:
							velocity.x = lerp(velocity.x, 0.0, 0.05)
						else:
							velocity.x = move_toward(velocity.x, 0, Global.player_speed)
						$Sprite2D.play("static")
				else:
					velocity.x = 0
			else:
				velocity = Vector2(0,0)
	
	if Global.player_energy <= 0:
		Global.player_speed = NORMAL_SPEED
		
	
	if Global.player_energy < Global.player_maxenergy:
		if Global.player_speed <= NORMAL_SPEED:
			if $EnergyDelay.is_stopped():
				$EnergyDelay.start(3.0)
		elif not ($LightAttackAngular/AngularLight.enabled or $LightAttackRadial/RadialLight.enabled):
			if $EnergyDelay.is_stopped():
				$EnergyDelay.start(3.0)
		elif velocity == Vector2(0, gravity * delta) and Global.player_speed > NORMAL_SPEED:
			if $EnergyDelay.is_stopped():
				$EnergyDelay.start(3.0)
		else:
			$EnergyDelay.start(3.0)
			$EnergyRegeneration.stop()
			
	
	if Input.is_action_just_pressed("SpeedChange"):
		if not on_quicksand:
			if Global.player_speed == HALF_SPEED:
				Global.player_speed = NORMAL_SPEED
			elif Global.player_speed == NORMAL_SPEED:
				Global.player_speed = DOUBLE_SPEED
			elif Global.player_speed == DOUBLE_SPEED:
				Global.player_speed = TRIPLE_SPEED
			elif Global.player_speed == TRIPLE_SPEED:
				Global.player_speed = QUADRUPLE_SPEED
			elif Global.player_speed == QUADRUPLE_SPEED:
				Global.player_speed = HALF_SPEED
	
	if direction_x == 1:
		$Sprite2D.offset.x = 160
		$Sprite2D.flip_h = false
	elif direction_x == -1:
		$Sprite2D.offset.x = -160
		$Sprite2D.flip_h = true
	
	if Input.is_action_pressed("Attack"):
		if not Global.spectator:
			if can_attack:
				$Sprite2D.play("attack")
				is_attacking = true
				$AttackCooldown.start(1 / attack_speed)
				can_attack = false
				if $Sprite2D.offset.x == 160:
					$FistAttack/AnimationPlayer.play("punch_right")
					$FistAttack/RightCollisionShape2D.set_deferred("disabled", false)
					$FistAttack/LeftCollisionShape2D.set_deferred("disabled", true)
				elif $Sprite2D.offset.x == -160:
					$FistAttack/AnimationPlayer.play("punch_left")
					$FistAttack/RightCollisionShape2D.set_deferred("disabled", true)
					$FistAttack/LeftCollisionShape2D.set_deferred("disabled", false)
	
	
	if Input.is_action_just_pressed("Retry"):
		if (not hardcore or not Global.spectator or not boss_mode) and not quick_retry:
			Global.player_health -= 1
			quick_retry = true
			death_engine()
	
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
			
			if tile and not tile_damage_taken:
				if collision.get_collider().get_cell_source_id(tile) in grass_obst_tiles:
					old_health = Global.player_health
					Global.player_health -= 1 * Settings.difficulty_amplifier
					tile_damage_taken = true
					if old_health == Global.player_maxhealth and old_health - Global.player_health >= Global.player_maxhealth:
						if not Global.u_cant_c_me:
							Global.u_cant_c_me_progress = 1
				elif collision.get_collider().get_cell_source_id(tile) in desert_obst_tiles:
					old_health = Global.player_health
					Global.player_health -= 3 * Settings.difficulty_amplifier
					tile_damage_taken = true
					if old_health == Global.player_maxhealth and old_health - Global.player_health >= Global.player_maxhealth:
						if not Global.u_cant_c_me:
							Global.u_cant_c_me_progress = 1
				elif collision.get_collider().get_cell_source_id(tile) in frost_obst_tiles:
					old_health = Global.player_health
					Global.player_health -= 7 * Settings.difficulty_amplifier
					tile_damage_taken = true
					if old_health == Global.player_maxhealth and old_health - Global.player_health >= Global.player_maxhealth:
						if not Global.u_cant_c_me:
							Global.u_cant_c_me_progress = 1
				elif collision.get_collider().get_cell_source_id(tile) == 5:
					old_health = Global.player_health
					if not hardcore:
						Global.player_health -= 8 * Settings.difficulty_amplifier
					else:
						Global.player_health -= 0.25 * Settings.difficulty_amplifier
						on_pad = true
						$LavaBounce.start(get_process_delta_time())
					tile_damage_taken = true
					if not Global.no_cheese:
						Global.no_cheese_progress = 1
					if old_health == Global.player_maxhealth and old_health - Global.player_health >= Global.player_maxhealth:
						if not Global.u_cant_c_me:
							Global.u_cant_c_me_progress = 1
				
				elif collision.get_collider().get_cell_source_id(tile) == 6:
					old_health = Global.player_health
					Global.player_health -= 6 * Settings.difficulty_amplifier
					tile_damage_taken = true
					if not Global.not_safe:
						Global.not_safe_progress = 1
					if old_health == Global.player_maxhealth and old_health - Global.player_health >= Global.player_maxhealth:
						if not Global.u_cant_c_me:
							Global.u_cant_c_me_progress = 1
							
				elif collision.get_collider().get_cell_source_id(tile) == 8:
					old_health = Global.player_health
					Global.player_health -= 1.5 * Settings.difficulty_amplifier
					death_engine()
					tile_damage_taken = true
					if old_health == Global.player_maxhealth and old_health - Global.player_health >= Global.player_maxhealth:
						if not Global.u_cant_c_me:
							Global.u_cant_c_me_progress = 1
				
				if tile_damage_taken:
					if not hardcore:
						death_engine()
					break
		
		if "Platforms" in collision.get_collider().name:
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
			
			if collision.get_collider().get_cell_source_id(collision.get_collider().local_to_map(position) + platform_tile_vector) in ice_tiles:
				on_ice = true
				if not Global.weeee:
					Global.weeee_progress = 1
			else:
				on_ice = false
			break
		
		if "TungstenCube" in collision.get_collider().name:
			if abs(collision.get_collider().get_linear_velocity().x) < MAX_VELOCITY:
				collision.get_collider().apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
	
	if Input.is_action_just_pressed("TorchToggle"):
		if not Global.fire_my_laser:
			Global.fire_my_laser_progress = 1
		if $LightAttackAngular/AngularLight.enabled:
			if not Global.spectator:
				$LightAttackAngular.set_deferred("monitoring", false)
				$LightAttackAngular.set_deferred("monitorable", false)
				$LightAttackAngular/AngularCollisionPolygon2D.set_deferred("disabled", true)
				
				$LightAttackRadial.set_deferred("monitoring", true)
				$LightAttackRadial.set_deferred("monitorable", true)
				$LightAttackRadial/RadialCollisionShape2D.set_deferred("disabled", false)
			
			$LightAttackAngular/AngularLight.enabled = false
			$LightAttackRadial/RadialLight.enabled = true
		elif $LightAttackRadial/RadialLight.enabled:
			if not Global.spectator:
				$LightAttackAngular.set_deferred("monitoring", false)
				$LightAttackAngular.set_deferred("monitorable", false)
				$LightAttackAngular/AngularCollisionPolygon2D.set_deferred("disabled", true)
				
				$LightAttackRadial.set_deferred("monitoring", false)
				$LightAttackRadial.set_deferred("monitorable", false)
				$LightAttackRadial/RadialCollisionShape2D.set_deferred("disabled", true)
			
			$LightAttackAngular/AngularLight.enabled = false
			$LightAttackRadial/RadialLight.enabled = false
		else:
			if not Global.spectator:
				$LightAttackAngular.set_deferred("monitoring", true)
				$LightAttackAngular.set_deferred("monitorable", true)
				$LightAttackAngular/AngularCollisionPolygon2D.set_deferred("disabled", false)
				
				$LightAttackRadial.set_deferred("monitoring", false)
				$LightAttackRadial.set_deferred("monitorable", false)
				$LightAttackRadial/RadialCollisionShape2D.set_deferred("disabled", true)
				
			$LightAttackAngular/AngularLight.enabled = true
			$LightAttackRadial/RadialLight.enabled = false
	
	if $LightAttackAngular/AngularLight.enabled or $LightAttackRadial/RadialLight.enabled:
		if not Global.spectator:
			Global.player_energy -= 2 / 60.0
			$EnergyRegeneration.stop()
			if Global.player_energy <= 0.0:
				$LightAttackAngular.set_deferred("monitoring", false)
				$LightAttackAngular.set_deferred("monitorable", false)
				$LightAttackAngular/AngularCollisionPolygon2D.set_deferred("disabled", true)
				$LightAttackAngular/AngularLight.enabled = false
				
				$LightAttackRadial.set_deferred("monitoring", false)
				$LightAttackRadial.set_deferred("monitorable", false)
				$LightAttackRadial/RadialCollisionShape2D.set_deferred("disabled", true)
				$LightAttackRadial/RadialLight.enabled = false

	for node in range(get_slide_collision_count()):
		var collision = get_slide_collision(node)
		if "Enemy" in collision.get_collider().name:
			old_health = Global.player_health
			Global.player_health -= 3 * Settings.difficulty_amplifier
			if old_health == Global.player_maxhealth and old_health - Global.player_health >= Global.player_maxhealth:
				if not Global.u_cant_c_me:
					Global.u_cant_c_me_progress = 1
			death_engine()
			break
	
	if touching_laser:
		if not damage_immune:
			Global.player_health -= 0.5 / (1.0 / get_process_delta_time()) * Settings.difficulty_amplifier
			laser_time_left -= delta
		else:
			laser_time_left = LASER_TIME
			if laser_time_left <= 0:
				damage_immune = true
				$DamageImmunity.start(2.5)
				$AnimationPlayerII.play("respawn_bossmode")


func death_engine():
	$DeathSFX.play()
	Global.no_stopping_now_progress += 1
	if quick_retry:
		velocity = Vector2(0,0)
		can_move = false
		$SpawnImmunity.start(1.1)
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.0)
		position = respawn_pos
		take_damage_respos = respawn_pos
		gravity = 980.0 * 1.75
		SignalBus.player_died.emit()
		quick_retry = false
	else:
		if Global.player_health > 0:
			gravity = respawn_gravity
			if boss_mode:
				$DamageImmunity.start(2.5)
				damage_immune = true
				$AnimationPlayerII.play("respawn_bossmode")
			else:
				velocity = Vector2(0,0)
				can_move = false
				$SpawnImmunity.start(1.1)
				$CollisionShape2D.set_deferred("disabled", true)
				$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.0)
				position = take_damage_respos
				gravity = respawn_gravity

		elif Global.player_health <= 0:
			SignalBus.player_died.emit()
			if Settings.gamemode == "Permadeath":
				spectator_mode()
			else:
				if boss_mode or hardcore:
					spectator_mode()
				else:
					position = respawn_pos
					take_damage_respos = respawn_pos
					Global.player_health = Global.player_maxhealth
					gravity = 980.0 * 1.75
				
		
		
		#if not boss_mode:
			#$DeathSFX.play()
#
			#Global.no_stopping_now_progress += 1
			#if quick_retry:
				#position = respawn_pos
				#take_damage_respos = respawn_pos
				#gravity = 980.0 * 1.75
				#SignalBus.player_died.emit()
			#if Global.player_health <= 0:
				#if Settings.gamemode == "Permadeath":
					#spectator_mode()
				#else:
					#if not hardcore:
						#position = respawn_pos
						#take_damage_respos = respawn_pos
						#Global.player_health = Global.player_maxhealth
						#gravity = 980.0 * 1.75
						#SignalBus.player_died.emit()
					#else:
						#spectator_mode()
			#elif Global.player_health >= 1:
				#position = take_damage_respos
				#gravity = respawn_gravity
		#else:
			#if Global.player_health >= 1:
				#$DeathSFX.play()
				#gravity = respawn_gravity
				#$DamageImmunity.start(2.5)
				#Global.no_stopping_now_progress += 1
				#damage_immune = true
				#$AnimationPlayerII.play("respawn_bossmode")
			#else:
				#spectator_mode()


func _on_res_pos_timer_timeout():
	if (is_on_floor() and gravity > 0.0) or (is_on_ceiling() and gravity < 0.0):
		take_damage_respos = position


func checkpoint_ii_hit():
	$Camera2D.enabled = true
	current_mode = player_modes[0]
	SignalBus.default_silhouette.emit()
	$Camera2D.limit_bottom = 768


func checkpoint_iv_hit():
	z_index = 1
	can_move = true
	$Camera2D.limit_left = -64
	$Camera2D.limit_top = 5504
	$Camera2D.limit_right = 6080
	$Camera2D.limit_bottom = 8192


func checkpoint_v_hit():
	$Camera2D.zoom = Vector2(0.8, 0.8)
	$Camera2D.limit_left = 5824
	$Camera2D.limit_top = 2784
	$Camera2D.limit_right = 11648
	$Camera2D.limit_bottom = 8192


func checkpoint_vi_hit():
	z_index = 1
	can_move = true
	current_mode = player_modes[1]
	$Camera2D.zoom = Vector2(1, 1)
	$Camera2D.limit_left = 2304
	$Camera2D.limit_top = -15360
	$Camera2D.limit_right = 17408
	$Camera2D.limit_bottom = -9792

func pad_launch():
	on_pad = true


func pad_delaunch():
	on_pad = false


func _on_keys_hold_timeout():
	Global.cant_let_go_progress = 1


func _on_spawn_immunity_timeout():
	$AnimationPlayerII.play("respawn_default")
	await $AnimationPlayerII.animation_finished
	$CollisionShape2D.set_deferred("disabled", false)
	quick_retry = false
	can_move = true


func update_torch():
	$LightAttackAngular/AngularLight.offset = Vector2(45.5 * (5 * Global.torch_level) - 32, 0)
	$LightAttackAngular/AngularLight.texture_scale = 5 * Global.torch_level
	var new_polygon = PackedVector2Array()
	for point in original_polygon:
		point = Vector2(point.x / 10 * (5 * Global.torch_level), point.y / 10 * (5 * Global.torch_level))
		new_polygon.append(point)
	$LightAttackAngular/AngularCollisionPolygon2D.polygon = new_polygon
	$LightAttackAngular/AngularCollisionPolygon2D.position = $LightAttackAngular/AngularLight.offset
	
	$LightAttackRadial/RadialLight.texture_scale = 2.5 * Global.torch_level
	$LightAttackRadial/RadialCollisionShape2D.shape.radius = (91 * $LightAttackRadial/RadialLight.texture_scale)/2


func _on_light_attack_radial_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		body.touching_light = true


func _on_light_attack_radial_body_exited(body: Node2D) -> void:
	if "Enemy" in body.name:
		body.touching_light = false


func _on_light_attack_angular_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		body.touching_light = true


func _on_light_attack_angular_body_exited(body: Node2D) -> void:
	if "Enemy" in body.name:
		body.touching_light = false


func _on_update_torch_timeout() -> void:
	update_torch()


func doomed():
	hardcore = true
	$Camera2D.zoom = Vector2(0.38, 0.38)
	$Camera2D.limit_left = 6656


func _on_lava_bounce_timeout() -> void:
	on_pad = false
	

func spectator_mode():
	$CollisionShape2D.set_deferred("disabled", true)
	
	$LightAttackRadial.set_deferred("monitorable", false)
	$LightAttackRadial.set_deferred("monitoring", false)
	$LightAttackRadial/RadialCollisionShape2D.set_deferred("disabled", true)
	$LightAttackRadial/RadialLight.enabled = true
	
	$LightAttackAngular.set_deferred("monitorable", false)
	$LightAttackAngular.set_deferred("monitoring", false)
	$LightAttackAngular/AngularCollisionPolygon2D.set_deferred("disabled", true)
	$LightAttackAngular/AngularLight.enabled = false
	
	$Camera2D.limit_left = -100000000
	$Camera2D.limit_bottom = 100000000
	$Camera2D.limit_top = -100000000
	$Camera2D.limit_right = 100000000
	$Camera2D.enabled = true
	$Camera2D.zoom = Vector2(1,1)
	
	Global.spectator = true
	Global.torch_level = 100
	Global.player_energy = INF
	gravity = 0
	on_pad = false
	velocity = Vector2.ZERO


func _on_fist_attack_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		body.health -= 4
		body.temp_stunned()
		

func _on_fist_attack_area_entered(area: Area2D) -> void:
	if "BreakableBlocks" in area.name:
		area.get_parent().get_parent().breakable_health -= 1
	elif "Boss" in area.name:
		Global.boss_health -= 8
	elif "Head" in area.name:
		Global.boss_health -= 16


func _on_attack_cooldown_timeout() -> void:
	can_attack = true
	$FistAttack/RightCollisionShape2D.set_deferred("disabled", true)
	$FistAttack/LeftCollisionShape2D.set_deferred("disabled", true)
	is_attacking = false


func undoomed():
	can_move = true
	z_index = 1
	current_mode = player_modes[1]
	hardcore = false
	position = Vector2(12640, 4992)
	respawn_pos = position
	take_damage_respos = position
	$Camera2D.zoom = Vector2(1,1)
	$Camera2D.limit_left = 12416
	$Camera2D.limit_top = 4224
	$Camera2D.limit_right = 16768
	$Camera2D.limit_bottom = 5696


func _on_light_attack_radial_area_entered(area: Area2D) -> void:
	if "Boss" in area.name:
		area.touching_light = true


func _on_light_attack_radial_area_exited(area: Area2D) -> void:
	if "Boss" in area.name:
		area.touching_light = false


func _on_light_attack_angular_area_entered(area: Area2D) -> void:
	if "Boss" in area.name:
		area.touching_light = true


func _on_light_attack_angular_area_exited(area: Area2D) -> void:
	if "Boss" in area.name:
		area.touching_light = false


func boss_spawned():
	$Camera2D.zoom = Vector2(0.8,0.8)
	$Camera2D.limit_left = 13952
	$Camera2D.limit_top = -15360
	$Camera2D.limit_right = 17408
	$Camera2D.limit_bottom = -13248
	boss_mode = true


func _on_damage_immunity_timeout() -> void:
	damage_immune = false


func _on_energy_regeneration_timeout() -> void:
	if Global.player_energy < Global.player_maxenergy:
		Global.player_energy += 5 / 60.0
		if Global.player_energy >= Global.player_maxenergy:
			$EnergyRegeneration.stop()


func _on_energy_delay_timeout() -> void:
	$EnergyRegeneration.start(get_process_delta_time())
	

func boss_defeated():
	Settings.gamemode = "Creative"
