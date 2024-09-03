extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.checkpoint_vi_hit.connect(checkpoint_vi_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if $ExitCave/Interactable.visible:
			for node in $ExitCave.get_overlapping_bodies():
				if "Player" in node.name:
					node.position = Vector2(2368, -10224)
					Global.escape_cave_progress = 1


func _on_exit_cave_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		$ExitCave/Interactable.show()


func _on_exit_cave_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		$ExitCave/Interactable.hide()
		
		
func checkpoint_vi_hit():
	$Checkpoints/CheckpointVI.set_deferred("monitorable", false)
	$Checkpoints/CheckpointVI.set_deferred("monitoring", false)
	$Checkpoints/CheckpointVI/CollisionShape2D.set_deferred("disabled", true)
