extends Node2D

var boulder = preload("res://Scenes/boulder.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.checkpoint_iii_hit.connect(checkpoint_iii_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if $PyramidAccess/Interactable.visible:
			print("Teleport Player")
			
	for node in $BoulderWreck.get_overlapping_bodies():
		if "Boulder" in node.name:
			node.queue_free()


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


func _on_hidden_key_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		hide()
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		$CollisionShape2D.set_deferred("disabled", true)
		Global.score += 1


func _on_pyramid_access_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		if not $Other/HiddenKey.visible:
			$PyramidAccess/Interactable.show()
		else:
			$PyramidAccess/Error.show()


func _on_pyramid_access_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$PyramidAccess/Interactable.hide()
		$PyramidAccess/Error.hide()
