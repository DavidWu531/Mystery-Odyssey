extends Area2D

var audio_files = ["res://Audio/SFX/retro-coin-1-236677.mp3", "res://Audio/SFX/retro-coin-4-236671.mp3"]

func _ready():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	$CollisionShape2D.set_deferred("disabled", false)


func _on_body_entered(body):
	if "Player" in body.name:
		hide()
		$"../NormalCoin".stream = load(audio_files.pick_random())
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		$CollisionShape2D.set_deferred("disabled", true)
		Global.score += 1
		Global.ooh_shiny_mine_progress += 1
		SignalBus.coin_collected.emit()
		$"../NormalCoin".play()
