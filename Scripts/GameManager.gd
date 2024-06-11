extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	$SceneCamera.position = Vector2(1104, -656)
	$SceneCamera.zoom = Vector2(0.725, 0.725)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func checkpoint_i_hit():
	$SceneCamera.position = Vector2(3504, -1336)
	$SceneCamera.zoom = Vector2(0.8, 0.8)
