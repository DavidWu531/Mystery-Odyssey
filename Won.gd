extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Result.text = "You beat the game!\nScore: " + str(Global.score) + "\nTime Taken: " + str(Global.time_elapsed + "s") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
