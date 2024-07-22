extends Node2D


func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	SignalBus.player_died.connect(player_died)
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)
	
	$SceneCamera.position = Vector2(1032, -648)
	$SceneCamera.zoom = Vector2(0.7, 0.7)


func _process(_delta):
	pass


func checkpoint_i_hit():
	$SceneCamera.position = Vector2(3232, -1416)
	$SceneCamera.zoom = Vector2(0.58, 0.58)
	Global.player_health = Global.player_maxhealth


func checkpoint_ii_hit():
	$SceneCamera.enabled = false
	Global.player_health = Global.player_maxhealth


func player_died():
	if SignalBus.checkpoint_i_emitted and SignalBus.checkpoint_i_available:
		for node in get_children():
			if "Player" in node.name:
				node.current_mode = node.player_modes[0]
				break
