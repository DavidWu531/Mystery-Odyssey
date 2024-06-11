extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func checkpoint_i_hit():
	$SceneCamera.enabled = false
