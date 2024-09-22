extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if $Settings.visible:
			$Settings.hide()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")


func _on_difficulty_pressed() -> void:
	if $Difficulty.text == "Difficulty: Easy":
		$Difficulty.text = "Difficulty: Normal"
		Settings.difficulty_amplifier = 1.0
	elif $Difficulty.text == "Difficulty: Normal":
		$Difficulty.text = "Difficulty: Hard"
		Settings.difficulty_amplifier = 2.0
	elif $Difficulty.text == "Difficulty: Hard":
		$Difficulty.text = "Difficulty: Extreme"
		Settings.difficulty_amplifier = 2.5
	elif $Difficulty.text == "Difficulty: Extreme":
		$Difficulty.text = "Difficulty: Easy"
		Settings.difficulty_amplifier = 0.5


func _on_gamemode_pressed() -> void:
	if $Gamemode.text == "Mode: Creative":
		$Gamemode.text = "Mode: Adventure"
		Settings.gamemode = "Adventure"
	elif $Gamemode.text == "Mode: Adventure":
		$Gamemode.text = "Mode: Speedrunner"
		Settings.gamemode = "Speedrunner"
	elif $Gamemode.text == "Mode: Speedrunner":
		$Gamemode.text = "Mode: Permadeath"
		Settings.gamemode = "Permadeath"
	elif $Gamemode.text == "Mode: Permadeath":
		$Gamemode.text = "Mode: Creative"
		Settings.gamemode = "Creative"
