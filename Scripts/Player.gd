extends CharacterBody2D

var speed = 0
const JUMP_VELOCITY = 625.0

var start_pos = Vector2(0,0)

const half_speed = 383.1
const normal_speed = 475.0
const double_speed = 590.7
const triple_speed = 713.9
const quadruple_speed = 878.2

var gravity = 980.0

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

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if "Spikes" in collision.get_collider().name:
			position = start_pos
			gravity = 980.0
		
	move_and_slide()
	
func _process(_delta):
	if position.y > 1000:
		position = start_pos
		gravity = 980.0
