extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	$CollisionShape2D.set_deferred("disabled", false)
	
	SignalBus.player_died.connect(player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_died():
	if $"../../Checkpoint/AnimatedSprite2D".animation == "Default":
		show()
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
