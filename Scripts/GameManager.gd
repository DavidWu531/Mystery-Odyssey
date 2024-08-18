extends Node2D


func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)
	SignalBus.checkpoint_iii_hit.connect(checkpoint_iii_hit)
	
	SignalBus.player_died.connect(player_died)
	
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


func checkpoint_iii_hit():
	Global.player_health = Global.player_maxhealth


func player_died():
	if SignalBus.checkpoint_i_emitted:
		for node in get_children():
			if "Player" in node.name:
				node.current_mode = node.player_modes[0]
				break
	if SignalBus.checkpoint_iii_emitted:
		for node in get_children():
			if "Player" in node.name:
				node.current_mode = node.player_modes[1]
				break


func _on_death_barrier_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.player_health -= 1
		body.death_engine()
