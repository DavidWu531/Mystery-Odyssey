extends RigidBody2D

var damage = 0
var x = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$SmallCollisionShape2D.disabled = true
	$MediumCollisionShape2D.disabled = true
	$BigCollisionShape2D.disabled = true
	x += 1
	var n = randi_range(1,3)
	match n:
		1:
			small()
		2: 
			medium()
		3: 
			big()


func _physics_process(_delta):
	name = "Boulder" + str(x)
	if position.y > 10000 or position.y < -10000:
		queue_free()
	

func _process(_delta):
	for body in get_colliding_bodies():
		if "Player" in body.name:
			Global.player_health -= damage
			body.death_engine()
			break


func big():
	mass = 10
	$Sprite2D.play("big")
	damage = 6
	$BigCollisionShape2D.disabled = false
	
func small():
	mass = 1
	$Sprite2D.play("small")
	damage = 1
	$SmallCollisionShape2D.disabled = false
	
func medium():
	mass = 5
	$Sprite2D.play("med")
	damage = 3
	$MediumCollisionShape2D.disabled = false
