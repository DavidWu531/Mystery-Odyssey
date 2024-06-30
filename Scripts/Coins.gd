extends Area2D

func _ready():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	$CollisionShape2D.set_deferred("disabled", false)


func _on_body_entered(body):
	if "Player" in body.name:
		hide()
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		$CollisionShape2D.set_deferred("disabled", true)
		Global.score += 1
		Global.ooh_shiny_mine_progress += 1
		SignalBus.coin_collected.emit()
