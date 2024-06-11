extends CanvasLayer

var time_elapsed = 0.00

func _process(delta):
	$Score.text = "Score: " + str(Global.score)
	
	$PlayerHealth.size = Vector2(Global.player_health * 38, 32)
	
	time_elapsed += delta
	$TimeElapsed.text = str(time_elapsed).pad_decimals(2)
	
	Global.player_energy -= 0.05
	
	$PlayerEnergy.max_value = 200
	$PlayerEnergy.value = Global.player_energy
	
