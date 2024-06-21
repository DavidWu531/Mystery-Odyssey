extends CanvasLayer

#var quests = { 
	#"Talk to the NPC": 0,
	#"Collect Coins": 5
#}
#var current_quest = quests.find_key([0])


func _process(delta):
	#$MainScreen/Quest/Label.text = "Quest: \n" + str(current_quest)
	
	$PauseMenu/Score.text = "Score: " + str(Global.score)
	
	$MainScreen/PlayerHealth.size = Vector2(Global.player_health * 38, 32)
	
	Global.time_elapsed += delta
	$MainScreen/TimeElapsed.text = str(Global.time_elapsed).pad_decimals(2)
	
	Global.player_energy -= 0.01
	
	$MainScreen/PlayerEnergy.max_value = 200
	$MainScreen/PlayerEnergy.value = Global.player_energy
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		$PauseMenu.show()

func _on_continue_pressed():
	$PauseMenu.hide()
	get_tree().paused = false
