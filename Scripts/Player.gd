extends CharacterBody2D

var speed = 0
const JUMP_VELOCITY = 625.0

var start_pos = Vector2(0,0)
var offsets = [Vector2(96, 32), Vector2(-96, 32), Vector2(96, -32), Vector2(-96, -32), Vector2(96, 32), Vector2(-96, 32), Vector2(96, -32), Vector2(-96, -32)]

const half_speed = 383.1
const normal_speed = 475.0
const double_speed = 590.7
const triple_speed = 713.9
const quadruple_speed = 878.2

var gravity = 980.0

var hr = 10
var mi = 0

var object_mode = "Default"

func _ready():
	speed = normal_speed
	start_pos = position

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
		if $Sprite2D.animation == "Temp1":
			$Sprite2D.play("Temp2")
		elif $Sprite2D.animation == "Temp2":
			$Sprite2D.play("Temp1")
	
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() or is_on_ceiling():
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

	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	$"../CanvasLayer/PlayerPos".text = str("Score: " + str(Global.score))
	
	move_and_slide()
	
func _process(_delta):
	if position.y > 1000:
		position = start_pos
		gravity = 980.0
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if "Spikes" in collision.get_collider().name:
			position = start_pos
			gravity = 980.0
		if "Coin" in collision.get_collider().name:
			collectible_kill()
			
	mi = int($"../AnimationPlayer".current_animation_position / $"../AnimationPlayer".current_animation_length * 60 * 24) % 60
	if mi == 59:
		hr += 0.2
		mi = 0
	if hr == 24:
		hr = 0
	
	$"../CanvasLayer/PlayerPos".text = str("Time: " + str("%02d" % hr) + ":" + str("%02d" % mi))

func collectible_kill():
	var granted = false
	# Top and Bottom Collision
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(32, 96)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(32, 96)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(-32, 96)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(-32, 96)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(32, -96)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(32, -96)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(-32, -96)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(-32, -96)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
				
	# Left and Right Collision
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(96, 32)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(96, 32)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(-96, 32)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(-96, 32)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(96, -32)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(96, -32)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
	if $"../Coin".get_cell_source_id(0, $"../Coin".local_to_map(global_position + Vector2(-96, -32)), false) != -1:
		$"../Coin".set_cell(0, $"../Coin".local_to_map(global_position + Vector2(-96, -32)), -1, Vector2i(0,0), 0)
		if granted == false:
			Global.score += 1
			Global.ooh_shiny_mine_progress += 1
			granted = true
