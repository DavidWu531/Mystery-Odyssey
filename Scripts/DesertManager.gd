extends Node2D

var boulder = preload("res://Scenes/boulder.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.checkpoint_iii_hit.connect(checkpoint_iii_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func checkpoint_iii_hit():
	$Checkpoints/CheckpointIII.set_deferred("monitorable", false)
	$Checkpoints/CheckpointIII.set_deferred("monitoring", false)
	$Checkpoints/CheckpointIII/CollisionShape2D.set_deferred("disabled", true)


func _on_quicksand_body_entered(body):
	if "Player" in body.name:
		body.velocity = Vector2(0,0)
		body.speed = 98.3
		body.gravity = 10.0
		body.jump_velocity = 210.0


func _on_quicksand_body_exited(body):
	if "Player" in body.name:
		body.speed = body.normal_speed
		body.gravity = 980.0 * 1.75
		body.jump_velocity = 625.0 * 1.4


func _on_boulder_timer_timeout():
	var new_boulder = boulder.instantiate()
	new_boulder.position = Vector2(14368, -1968)
	add_child(new_boulder)


func _on_boulder_wreck_body_entered(body):
	if "Boulder" in body.name:
		await get_tree().create_timer(0.75).timeout
		body.queue_free()
