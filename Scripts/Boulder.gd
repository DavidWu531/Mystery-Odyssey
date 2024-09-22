extends RigidBody2D

var damage = 0
var x = 0
var collided = false

func _ready():
	$SmallCollisionShape2D.disabled = true
	$MediumCollisionShape2D.disabled = true
	$BigCollisionShape2D.disabled = true
	$DamageManager/SmallCollisionShape2D.disabled = true
	$DamageManager/MediumCollisionShape2D.disabled = true
	$DamageManager/BigCollisionShape2D.disabled = true
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
	
	$QuestTracker.position = position

func _process(_delta):
	if $QuestTracker.is_colliding():
		if "Player" in $QuestTracker.get_collider().name:
			if not collided:
				SignalBus.avoided_rolling_boulder.emit()
				collided = true



func big():
	mass = 10
	$Sprite2D.play("big")
	damage = 6 * Settings.difficulty_amplifier
	$BigCollisionShape2D.disabled = false
	$DamageManager/BigCollisionShape2D.set_deferred("disabled", false)
	
func small():
	mass = 1
	$Sprite2D.play("small")
	damage = 1 * Settings.difficulty_amplifier
	$SmallCollisionShape2D.disabled = false
	$DamageManager/SmallCollisionShape2D.set_deferred("disabled", false)
	
func medium():
	mass = 5
	$Sprite2D.play("med")
	damage = 3 * Settings.difficulty_amplifier
	$MediumCollisionShape2D.disabled = false
	$DamageManager/MediumCollisionShape2D.set_deferred("disabled", false)

func _on_damage_manager_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.player_health -= damage
		body.death_engine()
