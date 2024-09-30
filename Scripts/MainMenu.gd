extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if $Options.visible:
			$Options.hide()
		if $Accomplishments.visible:
			$Accomplishments.hide()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")


func _on_difficulty_pressed() -> void:
	if $Options/Difficulty.text == "Difficulty: Easy":
		$Options/Difficulty.text = "Difficulty: Normal"
		Settings.difficulty_amplifier = 1.0
	elif $Options/Difficulty.text == "Difficulty: Normal":
		$Options/Difficulty.text = "Difficulty: Hard"
		Settings.difficulty_amplifier = 2.0
	elif $Options/Difficulty.text == "Difficulty: Hard":
		$Options/Difficulty.text = "Difficulty: Extreme"
		Settings.difficulty_amplifier = 2.5
	elif $Options/Difficulty.text == "Difficulty: Extreme":
		$Options/Difficulty.text = "Difficulty: Easy"
		Settings.difficulty_amplifier = 0.5


func _on_gamemode_pressed() -> void:
	if $Options/Gamemode.text == "Mode: Creative":
		$Options/Gamemode.text = "Mode: Adventure"
		Settings.gamemode = "Adventure"
	elif $Options/Gamemode.text == "Mode: Adventure":
		$Options/Gamemode.text = "Mode: Speedrunner"
		Settings.gamemode = "Speedrunner"
	elif $Options/Gamemode.text == "Mode: Speedrunner":
		$Options/Gamemode.text = "Mode: Permadeath"
		Settings.gamemode = "Permadeath"
	elif $Options/Gamemode.text == "Mode: Permadeath":
		$Options/Gamemode.text = "Mode: Creative"
		Settings.gamemode = "Creative"


func _on_achievements_pressed() -> void:
	$Accomplishments.show()


func _on_settings_pressed() -> void:
	$Options.show()


func _on_back_pressed() -> void:
	$Options.hide()
	$Accomplishments.hide()


func _on_bgm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, $Options/BGMSlider.value)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, $Options/SFXSlider.value)
