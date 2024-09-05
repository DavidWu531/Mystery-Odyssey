extends Area2D

var health = 1000

var touching_light = false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if touching_light:
		health -= 0.1


func projectile_shot():
	pass  # Fires projectiles every few seconds


func reinforcements():
	pass  # Summons small enemies to help fight
	

func laser_attack():
	pass  # Summons lasers 
