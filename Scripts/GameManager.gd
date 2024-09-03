extends Node2D


func _ready():
	SignalBus.checkpoint_i_hit.connect(checkpoint_i_hit)
	SignalBus.checkpoint_ii_hit.connect(checkpoint_ii_hit)
	SignalBus.checkpoint_iii_hit.connect(checkpoint_iii_hit)
	SignalBus.checkpoint_iv_hit.connect(checkpoint_iv_hit)
	SignalBus.checkpoint_v_hit.connect(checkpoint_v_hit)
	
	SignalBus.player_died.connect(player_died)
	
	$SceneCamera.position = Vector2(1032, -648)
	$SceneCamera.zoom = Vector2(0.7, 0.7)


func _process(_delta):
	pass


func checkpoint_i_hit():
	$SceneCamera.position = Vector2(3232, -1416)
	$SceneCamera.zoom = Vector2(0.58, 0.58)
	if Global.player_health == 1:
		if not Global.one_heart_escape:
			Global.one_heart_escape_progress = 1
	Global.player_health = Global.player_maxhealth


func checkpoint_ii_hit():
	$SceneCamera.enabled = false
	if Global.player_health == 1:
		if not Global.one_heart_escape:
			Global.one_heart_escape_progress = 1
	Global.player_health = Global.player_maxhealth


func checkpoint_iii_hit():
	if Global.player_health == 1:
		if not Global.one_heart_escape:
			Global.one_heart_escape_progress = 1
	Global.player_health = Global.player_maxhealth


func checkpoint_iv_hit():
	if Global.player_health == 1:
		if not Global.one_heart_escape:
			Global.one_heart_escape_progress = 1
	Global.player_health = Global.player_maxhealth
	$AnimationPlayer.seek(75.0)
	$AnimationPlayer.stop()


func checkpoint_v_hit():
	if Global.player_health == 1:
		if not Global.one_heart_escape:
			Global.one_heart_escape_progress = 1
	Global.player_health = Global.player_maxhealth


func checkpoint_vi_hit():
	if Global.player_health == 1:
		if not Global.one_heart_escape:
			Global.one_heart_escape_progress = 1
	Global.player_health = Global.player_maxhealth
	if not Global.escape_cave:
		Global.escape_cave_progress = 1


func player_died():
	if SignalBus.checkpoint_i_emitted:
		for node in get_children():
			if "Player" in node.name:
				node.current_mode = node.player_modes[0]
				SignalBus.default_silhouette.emit()
				break
	if SignalBus.checkpoint_iii_emitted:
		for node in get_children():
			if "Player" in node.name:
				node.current_mode = node.player_modes[1]
				SignalBus.double_jump_silhouette.emit()
				break


func _on_death_barrier_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.player_health -= 1
		body.death_engine()
