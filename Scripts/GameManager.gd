extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	$SceneCamera.position = Vector2(1032, -648)
	$SceneCamera.zoom = Vector2(0.7, 0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func checkpoint_i_hit():
	$SceneCamera.position = Vector2(2952, -1376)
