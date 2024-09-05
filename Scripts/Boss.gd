extends Area2D

var health = 500

var touching_light = false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if touching_light:
		health -= 0.1


func meteor():
	pass


func reinforcements():
	pass
	

func fire():
	pass
