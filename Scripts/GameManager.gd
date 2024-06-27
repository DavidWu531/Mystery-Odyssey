extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	SignalBus.player_died.connect(player_died)
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)
	
	$SceneCamera.position = Vector2(1032, -648)
	$SceneCamera.zoom = Vector2(0.7, 0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func checkpoint_i_hit():
	$SceneCamera.position = Vector2(2986, -1568)
	$SceneCamera.zoom = Vector2(0.69, 0.69)


func checkpoint_ii_hit():
	$SceneCamera.enabled = false


func player_died():
	if SignalBus.checkpoint_i_emitted and SignalBus.checkpoint_i_available:
		for node in get_children():
			if "Player" in node.name:
				node.current_mode = node.player_modes[0]
				break
