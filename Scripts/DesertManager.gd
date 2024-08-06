extends Node2D


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
