extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Result.text = "You beat the game!\nScore: " + str(Global.score) + "\nTime Taken: " + str(Global.time_elapsed).pad_decimals(2) + "s" 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
