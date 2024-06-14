extends CanvasLayer

func _process(delta):
	$PauseMenu/Score.text = "Score: " + str(Global.score)
	
	$PlayerHealth.size = Vector2(Global.player_health * 38, 32)
	
	Global.time_elapsed += delta
	$TimeElapsed.text = str(Global.time_elapsed).pad_decimals(2)
	
	Global.player_energy -= 0.01
	
	$PlayerEnergy.max_value = 200
	$PlayerEnergy.value = Global.player_energy
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		$PauseMenu.show()

func _on_continue_pressed():
	$PauseMenu.hide()
	get_tree().paused = false
