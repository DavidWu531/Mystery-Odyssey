extends CharacterBody2D

var speed = 0
const JUMP_VELOCITY = -625.0

var start_pos = Vector2(0,0)

const half_speed = 383.1
const normal_speed = 475.0
const double_speed = 590.7
const triple_speed = 713.9
const quadruple_speed = 878.2

var gravity = 980

var object_mode = "Default"
var game_mode = "Platformer"

func _ready():
	speed = normal_speed
	start_pos = position
	$"../Camera2D".position = Vector2(520,-984)
	$"../Camera2D".zoom = Vector2(0.4,0.4)
	floor_block_on_wall = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Jump") and (is_on_floor() or is_on_ceiling()):
		if object_mode == "Default":
			velocity.y = JUMP_VELOCITY
		elif object_mode == "Spider":
			if gravity > 0:
				velocity.y = -10000
			else:
				velocity.y = 10000
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
		
	move_and_slide()
	
func _process(_delta):
	if position.y > 1000:
		position = start_pos

func _on_key_body_entered(body):
	if "Player" in body.name:
		$"../Camera2D".zoom = Vector2(0.75,0.75)
		if randf() < 0.5:
			$"../Camera2D".position = Vector2(3792,-760)
			position = $"../Checkpoint".position
		else:
			$"../Camera2D".position = Vector2(6360,-1416)
			position = $"../Checkpoint2".position

func _on_checkpoint_body_entered(body):
	if "Player" in body.name:
		object_mode = "Spider"
		start_pos = $"../Checkpoint".position
		$"../Checkpoint/Sprite2D".play("hit")
		floor_block_on_wall = false

func _on_checkpoint_2_body_entered(body):
	if "Player" in body.name:
		speed = double_speed
		start_pos = $"../Checkpoint2".position
		$"../Checkpoint2/Sprite2D".play("hit")
